# 2026-03-14T12:47:11.844772200
import vitis

client = vitis.create_client()
client.set_workspace(path="HW2AVITIS1")

platform = client.create_platform_component(name = "top1",hw_design = "$COMPONENT_LOCATION/../../top1.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0")

platform = client.get_component(name="top1")
status = platform.build()

comp = client.create_app_component(name="hello_world",platform = "$COMPONENT_LOCATION/../top1/export/top1/top1.xpfm",domain = "standalone_ps7_cortexa9_0",template = "hello_world")

status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

vitis.dispose()

