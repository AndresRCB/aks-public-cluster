package e2e

import (
	"regexp"
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBasicApply(t *testing.T) {
	vars := map[string]interface{}{
		"resource_group_name": "e2e-test-rg-arcb",
	}
	test_helper.RunE2ETest(t, "../../", "examples/basic", terraform.Options{
		Upgrade: true,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		aksId, ok := output["test_aks_cluster_id"].(string)
		assert.True(t, ok)
		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.ContainerService/managedClusters/.+"), aksId)
		assert.NotEmpty(t, output["test_api_server_authorized_ip_ranges"])
	})
}

// func assertOutputNotEmpty(t *testing.T, output test_helper.TerraformOutput, name string) {
// 	o, ok := output[name].(string)
// 	assert.True(t, ok)
// 	assert.NotEqual(t, "", o)
// }
