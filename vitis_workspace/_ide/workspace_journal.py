# 2026-04-04T16:42:44.074440300
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis_workspace")

platform = client.create_platform_component(name = "system_wrapper",hw_design = "$COMPONENT_LOCATION/../../system_wrapper.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",compiler = "gcc")

comp = client.create_app_component(name="Zybo-Z7-10-Audio",platform = "$COMPONENT_LOCATION/../system_wrapper/export/system_wrapper/system_wrapper.xpfm",domain = "standalone_ps7_cortexa9_0")

platform = client.get_component(name="system_wrapper")
status = platform.build()

status = platform.build()

comp = client.get_component(name="Zybo-Z7-10-Audio")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

status = platform.build()

comp.build()

