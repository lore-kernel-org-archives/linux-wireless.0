Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:7032 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBZPK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 10:10:58 -0500
Message-ID: <530E03FF.2080608@broadcom.com> (sfid-20140226_161107_718928_03E4974A)
Date: Wed, 26 Feb 2014 16:10:55 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: merge issue with wireless-testing
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Our internal kernel repository was still dangling on 3.14-rc1 (last
merge from wireless-testing/master) so I thought it was time to tag
along and do a new merge of wireless-testing/master, but I get a ship
load of merge conflicts that I can not explain (see below). Did you
rebase between rc1 and rc4? Hope you can end my confusion.

Regards,
Arend

--8<-----------------------------------------------------------------
# Unmerged paths:
#   (use "git add/rm <file>..." as appropriate to mark resolution)
#
#	both modified:      Documentation/PCI/MSI-HOWTO.txt
#	both modified:      MAINTAINERS
#	both modified:      Makefile
#	both modified:      arch/arm/boot/dts/dove.dtsi
#	both added:         arch/arm/boot/dts/imx6dl-hummingboard.dts
#	both added:         arch/arm/boot/dts/imx6qdl-cubox-i.dtsi
#	both modified:      arch/arm/boot/dts/sama5d3.dtsi
#	both modified:      arch/arm/boot/dts/ste-href.dtsi
#	both modified:      arch/arm/boot/dts/tegra114.dtsi
#	both modified:      arch/arm/boot/dts/tegra20.dtsi
#	both modified:      arch/arm/boot/dts/tegra30-cardhu.dtsi
#	both modified:      arch/arm/boot/dts/tegra30.dtsi
#	both modified:      arch/arm/kernel/setup.c
#	both added:         arch/arm/mach-hisi/Kconfig
#	both modified:      arch/arm/mach-imx/clk-imx6sl.c
#	both added:         arch/arm/mach-moxart/Kconfig
#	both modified:      arch/arm/mach-omap2/Kconfig
#	both modified:      arch/arm/mach-zynq/common.c
#	both modified:      arch/arm64/include/uapi/asm/kvm.h
#	both modified:      arch/arm64/mm/dma-mapping.c
#	both modified:      arch/microblaze/kernel/head.S
#	both modified:      arch/mips/include/asm/fpu.h
#	both modified:      arch/powerpc/include/asm/pgtable.h
#	both modified:      arch/powerpc/platforms/powernv/pci-ioda.c
#	both modified:      arch/powerpc/platforms/powernv/pci.c
#	both modified:      arch/powerpc/platforms/powernv/setup.c
#	both modified:      arch/powerpc/platforms/pseries/pci.c
#	both modified:      arch/s390/kernel/compat_wrapper.S
#	both modified:      arch/x86/Kconfig
#	both modified:      arch/x86/include/asm/efi.h
#	both modified:      arch/x86/include/asm/tsc.h
#	both modified:      arch/x86/kernel/cpu/microcode/amd_early.c
#	both modified:      arch/x86/kernel/irq.c
#	both modified:      arch/x86/kernel/tsc.c
#	both added:         arch/x86/kernel/tsc_msr.c
#	both modified:      arch/x86/mm/numa.c
#	both modified:      arch/x86/platform/efi/efi.c
#	both modified:      arch/x86/platform/efi/efi_64.c
#	both modified:      arch/x86/xen/enlighten.c
#	both modified:      block/blk-merge.c
#	both modified:      block/blk-mq.c
#	both modified:      block/blk-mq.h
#	both modified:      drivers/acpi/container.c
#	both modified:      drivers/acpi/scan.c
#	both modified:      drivers/ata/ahci.c
#	both modified:      drivers/ata/sata_mv.c
#	both added:         drivers/base/component.c
#	both modified:      drivers/block/null_blk.c
#	both modified:      drivers/clocksource/bcm_kona_timer.c
#	both modified:      drivers/cpufreq/intel_pstate.c
#	both modified:      drivers/dma/Kconfig
#	both added:         drivers/gpio/gpio-xtensa.c
#	both modified:      drivers/gpu/drm/ast/ast_fb.c
#	both modified:      drivers/gpu/drm/cirrus/cirrus_fbdev.c
#	both modified:      drivers/gpu/drm/exynos/exynos_drm_drv.c
#	both modified:      drivers/gpu/drm/i915/intel_display.c
#	both modified:      drivers/gpu/drm/i915/intel_dp.c
#	both modified:      drivers/gpu/drm/i915/intel_ringbuffer.c
#	both modified:      drivers/gpu/drm/mgag200/mgag200_fb.c
#	both modified:      drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c
#	both added:         drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
#	both modified:      drivers/gpu/drm/nouveau/core/engine/device/nv40.c
#	both modified:      drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c
#	both modified:      drivers/gpu/drm/nouveau/core/engine/graph/nv50.c
#	both modified:      drivers/gpu/drm/nouveau/nouveau_acpi.c
#	both modified:      drivers/gpu/drm/nouveau/nouveau_bo.c
#	both modified:      drivers/gpu/drm/radeon/atombios_crtc.c
#	both modified:      drivers/gpu/drm/radeon/kv_dpm.c
#	both modified:      drivers/gpu/drm/radeon/radeon_drv.c
#	both modified:      drivers/gpu/drm/radeon/si_dpm.c
#	both modified:      drivers/gpu/drm/ttm/ttm_object.c
#	both modified:      drivers/gpu/drm/ttm/ttm_tt.c
#	both modified:      drivers/gpu/drm/vmwgfx/svga3d_reg.h
#	both modified:      drivers/gpu/drm/vmwgfx/svga_reg.h
#	both modified:      drivers/gpu/drm/vmwgfx/vmwgfx_context.c
#	both modified:      drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
#	both modified:      drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
#	both modified:      drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
#	both modified:      drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c
#	both added:         drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
#	both added:         drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
#	both modified:      drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
#	both modified:      drivers/hid/hid-ids.h
#	both modified:      drivers/hid/hid-sensor-hub.c
#	both modified:      drivers/iio/accel/bma180.c
#	both modified:      drivers/infiniband/hw/mlx4/main.c
#	both modified:      drivers/infiniband/hw/ocrdma/ocrdma_main.c
#	both added:         drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
#	both modified:      drivers/infiniband/ulp/isert/ib_isert.c
#	both modified:      drivers/md/bcache/bcache.h
#	both modified:      drivers/md/bcache/bset.c
#	both modified:      drivers/md/bcache/btree.c
#	both added:         drivers/md/bcache/extents.c
#	both modified:      drivers/md/bcache/request.c
#	both modified:      drivers/md/bcache/sysfs.c
#	both modified:      drivers/media/i2c/adv7842.c
#	both added:         drivers/media/i2c/s5k5baf.c
#	both modified:      drivers/media/platform/exynos4-is/fimc-core.c
#	both modified:      drivers/media/platform/exynos4-is/fimc-lite.c
#	both modified:      drivers/media/platform/s5p-jpeg/jpeg-core.c
#	both modified:      drivers/media/v4l2-core/videobuf2-core.c
#	both added:         drivers/mfd/max14577.c
#	both modified:      drivers/mfd/max8997.c
#	both modified:      drivers/mfd/max8998.c
#	both modified:      drivers/mfd/sec-core.c
#	both modified:      drivers/mfd/tps65217.c
#	both added:         drivers/misc/genwqe/card_dev.c
#	both modified:      drivers/net/bonding/bond_main.c
#	both modified:      drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
#	both modified:      drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
#	both modified:      drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
#	both modified:      drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
#	both modified:      drivers/net/ethernet/lantiq_etop.c
#	both modified:      drivers/net/ethernet/mellanox/mlx4/en_tx.c
#	both modified:      drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
#	both modified:      drivers/net/ethernet/stmicro/stmmac/Kconfig
#	both modified:      drivers/net/ethernet/stmicro/stmmac/Makefile
#	both modified:      drivers/net/ethernet/stmicro/stmmac/stmmac.h
#	both modified:      drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
#	both modified:      drivers/net/ethernet/ti/cpsw.c
#	both modified:      drivers/net/ethernet/tile/tilegx.c
#	both modified:      drivers/net/hyperv/netvsc_drv.c
#	both modified:      drivers/net/macvlan.c
#	both modified:      drivers/net/phy/phy_device.c
#	both modified:      drivers/net/team/team.c
#	both modified:      drivers/net/tun.c
#	both modified:      drivers/net/usb/r8152.c
#	both modified:      drivers/net/vxlan.c
#	both modified:      drivers/net/wireless/ath/ath10k/htt_rx.c
#	both modified:      drivers/net/wireless/ath/ath10k/mac.c
#	both modified:      drivers/net/wireless/ath/ath9k/ar9003_calib.c
#	both modified:      drivers/net/wireless/ath/ath9k/ath9k.h
#	both modified:      drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
#	both modified:      drivers/net/wireless/ath/ath9k/hw.c
#	both modified:      drivers/net/wireless/ath/ath9k/main.c
#	both modified:      drivers/net/wireless/ath/ath9k/recv.c
#	both modified:      drivers/net/wireless/b43/xmit.c
#	both modified:      drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
#	both added:         drivers/net/wireless/brcm80211/brcmfmac/chip.c
#	both modified:      drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
#	both modified:      drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
#	both modified:      drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
#	both modified:      drivers/net/wireless/iwlwifi/iwl-prph.h
#	both modified:      drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
#	both modified:      drivers/net/wireless/iwlwifi/mvm/mac80211.c
#	both modified:      drivers/net/wireless/iwlwifi/mvm/nvm.c
#	both modified:      drivers/net/wireless/iwlwifi/mvm/ops.c
#	deleted by them:    drivers/net/wireless/iwlwifi/mvm/power_legacy.c
#	both modified:      drivers/net/wireless/iwlwifi/mvm/rs.c
#	both modified:      drivers/net/wireless/iwlwifi/mvm/scan.c
#	both modified:      drivers/net/wireless/iwlwifi/mvm/tx.c
#	both modified:      drivers/net/wireless/iwlwifi/pcie/drv.c
#	both modified:      drivers/net/wireless/iwlwifi/pcie/rx.c
#	both modified:      drivers/net/wireless/iwlwifi/pcie/tx.c
#	both modified:      drivers/net/wireless/mac80211_hwsim.c
#	both modified:      drivers/net/wireless/mac80211_hwsim.h
#	both modified:      drivers/net/wireless/mwifiex/fw.h
#	both modified:      drivers/net/wireless/mwifiex/main.c
#	both modified:      drivers/net/wireless/mwifiex/scan.c
#	both modified:      drivers/net/wireless/mwifiex/usb.c
#	both modified:      drivers/net/xen-netback/common.h
#	both modified:      drivers/net/xen-netback/interface.c
#	both modified:      drivers/net/xen-netback/netback.c
#	both modified:      drivers/of/base.c
#	both modified:      drivers/of/of_mdio.c
#	both modified:      drivers/pci/hotplug/acpiphp_glue.c
#	both modified:      drivers/pci/msi.c
#	both modified:      drivers/phy/Kconfig
#	both modified:      drivers/phy/phy-core.c
#	both added:         drivers/phy/phy-mvebu-sata.c
#	both modified:      drivers/power/isp1704_charger.c
#	both modified:      drivers/regulator/core.c
#	both added:         drivers/regulator/max14577.c
#	both modified:      drivers/spi/Kconfig
#	both added:         drivers/staging/android/ion/compat_ion.c
#	both added:         drivers/staging/android/ion/ion_dummy_driver.c
#	both added:         drivers/staging/android/ion/ion_heap.c
#	both added:         drivers/staging/android/ion/ion_priv.h
#	both added:         drivers/staging/android/ion/ion_system_heap.c
#	both modified:      drivers/staging/bcm/Bcmnet.c
#	both modified:      drivers/staging/iio/adc/mxs-lradc.c
#	both modified:      drivers/staging/imx-drm/imx-drm-core.c
#	both added:         drivers/staging/imx-drm/imx-hdmi.c
#	both modified:      drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
#	both modified:      drivers/staging/netlogic/xlr_net.c
#	both modified:      drivers/staging/rtl8188eu/os_dep/os_intfs.c
#	both added:         drivers/staging/rtl8821ae/Kconfig
#	both added:         drivers/staging/rtl8821ae/wifi.h
#	both modified:      drivers/target/target_core_alua.c
#	both modified:      drivers/target/target_core_sbc.c
#	both modified:      drivers/target/target_core_spc.c
#	both modified:      drivers/tty/n_tty.c
#	both modified:      drivers/usb/core/driver.c
#	both modified:      drivers/usb/dwc2/core.c
#	both modified:      drivers/usb/dwc2/platform.c
#	both modified:      drivers/usb/gadget/f_fs.c
#	both modified:      drivers/usb/gadget/s3c2410_udc.c
#	both modified:      drivers/usb/host/xhci-ring.c
#	both modified:      drivers/usb/host/xhci.c
#	both modified:      drivers/usb/host/xhci.h
#	both modified:      drivers/usb/musb/musb_core.c
#	both modified:      drivers/usb/musb/musb_virthub.c
#	both modified:      drivers/video/omap2/dss/dispc.c
#	both modified:      drivers/video/omap2/dss/dpi.c
#	both modified:      drivers/video/omap2/dss/sdi.c
#	both modified:      drivers/watchdog/Kconfig
#	both modified:      drivers/xen/events/events_base.c
#	both modified:      fs/bio.c
#	both modified:      fs/btrfs/disk-io.c
#	both modified:      fs/btrfs/extent-tree.c
#	both modified:      fs/btrfs/inode.c
#	both modified:      fs/btrfs/ioctl.c
#	both modified:      fs/btrfs/send.c
#	both modified:      fs/btrfs/sysfs.c
#	both added:         fs/ceph/acl.c
#	both modified:      fs/ceph/dir.c
#	both modified:      fs/ceph/super.h
#	both modified:      fs/ceph/xattr.c
#	both modified:      fs/cifs/cifsglob.h
#	both modified:      fs/jfs/acl.c
#	both modified:      fs/jfs/xattr.c
#	both added:         fs/kernfs/dir.c
#	both modified:      fs/namei.c
#	both modified:      fs/nfs/nfs3acl.c
#	both modified:      fs/nfsd/nfs4acl.c
#	both modified:      fs/posix_acl.c
#	both modified:      fs/xfs/xfs_iops.c
#	both modified:      fs/xfs/xfs_log_cil.c
#	both modified:      include/linux/bio.h
#	both modified:      include/linux/mmc/sdio_ids.h
#	both modified:      include/linux/netdevice.h
#	both modified:      include/linux/of.h
#	both modified:      include/linux/pci.h
#	both modified:      include/linux/spi/spi.h
#	both modified:      include/linux/syscalls.h
#	both modified:      include/net/cfg80211.h
#	both modified:      include/trace/events/power.h
#	both modified:      include/uapi/drm/vmwgfx_drm.h
#	both modified:      include/uapi/linux/nl80211.h
#	both modified:      kernel/cgroup.c
#	both modified:      kernel/sched/core.c
#	both added:         kernel/sched/cpudeadline.c
#	both added:         kernel/sched/deadline.c
#	both modified:      kernel/sched/sched.h
#	both modified:      mm/huge_memory.c
#	both modified:      mm/memory-failure.c
#	both modified:      mm/mprotect.c
#	both modified:      mm/slub.c
#	both modified:      net/batman-adv/bat_iv_ogm.c
#	both modified:      net/batman-adv/originator.c
#	both modified:      net/bluetooth/hci_core.c
#	both modified:      net/bluetooth/l2cap_core.c
#	both modified:      net/bluetooth/rfcomm/tty.c
#	both modified:      net/ceph/messenger.c
#	both modified:      net/ceph/osd_client.c
#	both modified:      net/core/dev.c
#	both modified:      net/core/flow_dissector.c
#	both modified:      net/core/rtnetlink.c
#	both modified:      net/ieee802154/6lowpan.c
#	both modified:      net/ipv4/devinet.c
#	both modified:      net/ipv4/ip_forward.c
#	both modified:      net/ipv4/ip_tunnel.c
#	both modified:      net/ipv4/netfilter/Kconfig
#	both modified:      net/ipv4/tcp_output.c
#	both modified:      net/ipv4/udp_offload.c
#	both modified:      net/ipv6/icmp.c
#	both modified:      net/ipv6/ip6_output.c
#	both modified:      net/ipv6/netfilter/Kconfig
#	both modified:      net/mac80211/cfg.c
#	both modified:      net/mac80211/debugfs_netdev.c
#	both modified:      net/mac80211/ibss.c
#	both modified:      net/mac80211/iface.c
#	both modified:      net/mac80211/tx.c
#	both modified:      net/netfilter/Kconfig
#	both modified:      net/netfilter/Makefile
#	both modified:      net/netfilter/nf_tables_api.c
#	both modified:      net/netfilter/nft_log.c
#	both added:         net/netfilter/nft_queue.c
#	both modified:      net/netfilter/nft_reject.c
#	both modified:      net/nfc/nci/core.c
#	both modified:      net/openvswitch/datapath.c
#	both modified:      net/openvswitch/flow_table.c
#	both modified:      net/packet/af_packet.c
#	both added:         net/sched/sch_pie.c
#	both modified:      net/sctp/associola.c
#	both modified:      net/sctp/socket.c
#	both modified:      net/wireless/ap.c
#	both modified:      net/wireless/mesh.c
#	both modified:      net/wireless/nl80211.c
#	both modified:      sound/pci/hda/hda_codec.c
#	both modified:      sound/pci/hda/patch_analog.c
#	both modified:      sound/pci/hda/patch_realtek.c
#	both added:         sound/pci/hda/thinkpad_helper.c
#	both modified:      sound/soc/davinci/davinci-mcasp.c
#	both added:         sound/soc/fsl/fsl_esai.c
#	both added:         sound/soc/fsl/fsl_esai.h
#	both modified:      sound/usb/mixer_maps.c
#	both modified:      tools/perf/util/machine.c
#	both modified:      tools/perf/util/probe-event.c
#
