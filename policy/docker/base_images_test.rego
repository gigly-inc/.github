package docker.base_images_test

import rego.v1

import data.docker.base_images

image := "${BASE_REGISTRY}/docker/library/node:22-alpine@sha256:5b05da3f938f1c604b24c633646d48805a6667f378cb4908438616f3cc48a0bf"

# The parser returns a list holding one list of instructions.
denied(dockerfile) := messages if {
	some instructions in parse_config("dockerfile", dockerfile)
	messages := base_images.deny with input as instructions
}

test_cached_pinned_images_and_earlier_stages_pass if {
	count(denied(concat("\n", [
		"ARG BASE_REGISTRY=public.ecr.aws",
		sprintf("FROM --platform=$BUILDPLATFORM %s AS build", [image]),
		"FROM Build as Carry",
		sprintf("FROM %s", [image]),
		"COPY --from=carry /app /app",
		"COPY --from=0 /app /app",
		"RUN --mount=type=bind,from=build,target=/b --mount=type=cache,target=/c true",
		"FROM scratch",
	]))) == 0
}

test_an_image_from_another_registry_fails if {
	denied("FROM docker.io/library/node:22-alpine") == {
		"FROM docker.io/library/node:22-alpine: use ${BASE_REGISTRY}/<image>@sha256:<digest> or an earlier stage",
	}
}

test_an_image_without_a_digest_fails if {
	count(denied("FROM ${BASE_REGISTRY}/docker/library/node:22-alpine")) == 1
}

test_a_malformed_digest_fails if {
	count(denied(sprintf("FROM %s0", [image]))) == 1
}

test_an_image_through_another_variable_fails if {
	count(denied(replace(sprintf("FROM %s", [image]), "BASE_REGISTRY", "REGISTRY"))) == 1
}

test_an_image_behind_another_registry_fails if {
	count(denied(sprintf("FROM docker.io/%s", [image]))) == 1
}

test_a_stage_naming_itself_fails if {
	count(denied("FROM base AS base")) == 1
}

test_a_stage_named_later_fails if {
	count(denied(concat("\n", [
		"FROM later",
		sprintf("FROM %s AS later", [image]),
	]))) == 1
}

test_copy_from_an_external_image_fails if {
	denied(sprintf("FROM %s\nCOPY --from=alpine:3 /x /x", [image])) == {
		"COPY --from=alpine:3: use ${BASE_REGISTRY}/<image>@sha256:<digest> or an earlier stage",
	}
}

test_copy_from_a_later_stage_index_fails if {
	count(denied(sprintf("FROM %s\nCOPY --from=1 /x /x\nFROM %s", [image, image]))) == 1
}

test_copy_from_a_cached_pinned_image_passes if {
	count(denied(sprintf("FROM %s\nCOPY --from=%s /x /x", [image, image]))) == 0
}

test_a_mount_from_an_external_image_fails if {
	denied(sprintf("FROM %s\nRUN --mount=type=bind,from=busybox,target=/b true", [image])) == {
		"RUN --mount from=busybox: use ${BASE_REGISTRY}/<image>@sha256:<digest> or an earlier stage",
	}
}

test_a_mount_from_key_in_capitals_fails if {
	count(denied(sprintf("FROM %s\nRUN --mount=type=bind,FROM=busybox,target=/b true", [image]))) == 1
}

test_onbuild_fails if {
	denied(sprintf("FROM %s\nONBUILD COPY --from=alpine:3 /x /x", [image])) == {
		"ONBUILD COPY: not allowed, as its sources cannot be checked",
	}
}
