# Every image a Dockerfile pulls comes through the registry's pull-through cache,
# named by ${BASE_REGISTRY}, and is pinned by digest. Earlier stages and scratch
# need neither.
package docker.base_images

import rego.v1

pinned := `^\$\{BASE_REGISTRY\}/[^@\s]+@sha256:[0-9a-f]{64}$`

stages := [instruction | some instruction in input; instruction.Cmd == "from"]

deny contains msg if {
	some instruction in input
	instruction.Cmd == "from"
	image := instruction.Value[0]
	not image == "scratch"
	not allowed(image, instruction.Stage)
	msg := sprintf("FROM %s: use ${BASE_REGISTRY}/<image>@sha256:<digest> or an earlier stage", [image])
}

deny contains msg if {
	some instruction in input
	instruction.Cmd == "copy"
	some flag in instruction.Flags
	startswith(flag, "--from=")
	source := substring(flag, 7, -1)
	not allowed(source, instruction.Stage)
	not earlier_index(source, instruction.Stage)
	msg := sprintf("COPY --from=%s: use ${BASE_REGISTRY}/<image>@sha256:<digest> or an earlier stage", [source])
}

deny contains msg if {
	some instruction in input
	instruction.Cmd == "run"
	some flag in instruction.Flags
	startswith(flag, "--mount=")
	some option in split(substring(flag, 8, -1), ",")
	parts := split(option, "=")
	lower(trim_space(parts[0])) == "from"
	source := concat("=", array.slice(parts, 1, count(parts)))
	not allowed(source, instruction.Stage)
	not earlier_index(source, instruction.Stage)
	msg := sprintf("RUN --mount from=%s: use ${BASE_REGISTRY}/<image>@sha256:<digest> or an earlier stage", [source])
}

# Its triggers' flags are not parsed, so where they copy from cannot be seen.
deny contains msg if {
	some instruction in input
	instruction.Cmd == "onbuild"
	msg := sprintf("ONBUILD %s: not allowed, as its sources cannot be checked", [instruction.SubCmd])
}

allowed(image, _) if regex.match(pinned, image)

# Stage names are case-insensitive, and a stage can only use one before it.
allowed(name, stage) if {
	some index, earlier in stages
	index < stage
	count(earlier.Value) == 3
	upper(earlier.Value[1]) == "AS"
	lower(earlier.Value[2]) == lower(name)
}

earlier_index(source, stage) if {
	regex.match(`^[0-9]+$`, source)
	to_number(source) < stage
}
