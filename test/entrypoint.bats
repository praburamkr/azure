#!/usr/bin/env bats

function setup() {
  # Override PATH to mock out the az cli
  export PATH="$BATS_TEST_DIRNAME/bin:$PATH"
  # Override HOME so we don't overwrite its contents
  export HOME="$BATS_TMPDIR"
  # Ensure GITHUB_WORKSPACE is set
  export GITHUB_WORKSPACE="${GITHUB_WORKSPACE-"${BATS_TEST_DIRNAME}/.."}"
}

@test "entrypoint runs successfully" {
  run $GITHUB_WORKSPACE/entrypoint.sh
  [ "$status" -eq 0 ]
}

@test "AZ_OUTPUT_FORMAT defaults to json" {
  run $GITHUB_WORKSPACE/entrypoint.sh help
  [ "${lines[1]}" = "AZ_OUTPUT_FORMAT: json" ]
}

@test "AZ_OUTPUT_FORMAT may be overridden" {
  export AZ_OUTPUT_FORMAT=text
  run $GITHUB_WORKSPACE/entrypoint.sh help
  [ "$status" -eq 0 ]
  [ "${lines[1]}" = "AZ_OUTPUT_FORMAT: text" ]
}

@test "PEM is written" {
  export AZURE_SERVICE_PEM="azure_service_pem"
  run $GITHUB_WORKSPACE/entrypoint.sh help
  [ "$status" -eq 0 ]
  [ -f "$HOME/.az/key.pem" ]
  [ $( cat "$HOME/.az/key.pem" ) = "azure_service_pem" ]
}
