Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37569 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbbKCUjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 15:39:32 -0500
Received: by wicfv8 with SMTP id fv8so19657891wic.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2015 12:39:31 -0800 (PST)
Subject: Re: Ralink RT5592 5Ghz capability not working
To: Alberto Mattea <alberto@mattea.info>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <5638B98F.2080908@gmail.com> <13779729.DhZWn6HO5Q@alby>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <56391B82.2030105@gmail.com> (sfid-20151103_213936_651953_4CCB13E1)
Date: Tue, 3 Nov 2015 21:39:30 +0100
MIME-Version: 1.0
In-Reply-To: <13779729.DhZWn6HO5Q@alby>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2015 07:10 PM, Alberto Mattea wrote:

> Hey, thanks for your answer. The device definitely isn't a RT3091, so do you 
> think it's some sort of an OEM hybrid?

I don't know. Open the device or look for photos at FCC site.
wikidevi.com usually has links to it.

> Do you think it would be better to report this to the openwrt bugzilla?

Yes.
As you can see, *OpenWrt doesn't run a standard Linux kernel* :

-rw------- 1 xose xose   633 Nov  3 21:10 000-fix_kconfig.patch
-rw------- 1 xose xose  5634 Nov  3 21:10 001-fix_build.patch
-rw------- 1 xose xose  1651 Nov  3 21:10 002-change_allconfig.patch
-rw------- 1 xose xose  1188 Nov  3 21:10 003-remove_bogus_modparams.patch
-rw------- 1 xose xose   319 Nov  3 21:10 010-disable_rfkill.patch
-rw------- 1 xose xose   875 Nov  3 21:10 030-rt2x00_options.patch
-rw------- 1 xose xose   222 Nov  3 21:10 040-brcmutil_option.patch
-rw------- 1 xose xose   622 Nov  3 21:10 050-lib80211_option.patch
-rw------- 1 xose xose  3766 Nov  3 21:10 060-no_local_ssb_bcma.patch
-rw------- 1 xose xose   391 Nov  3 21:10 070-ath_common_config.patch
-rw------- 1 xose xose   390 Nov  3 21:10 080-disable_clk_backport.patch
-rw------- 1 xose xose 10948 Nov  3 21:10 100-remove-cryptoapi-dependencies.patch
-rw------- 1 xose xose   400 Nov  3 21:10 110-mac80211_keep_keys_on_stop_ap.patch
-rw------- 1 xose xose  1292 Nov  3 21:10 120-cfg80211_allow_perm_addr_change.patch
-rw------- 1 xose xose  1906 Nov  3 21:10 150-disable_addr_notifier.patch
-rw------- 1 xose xose  1309 Nov  3 21:10 201-ath5k-WAR-for-AR71xx-PCI-bug.patch
-rw------- 1 xose xose   385 Nov  3 21:10 210-ap_scan.patch
-rw------- 1 xose xose   972 Nov  3 21:10 300-ath9k-force-rx_clear-when-disabling-rx.patch
-rw------- 1 xose xose  3643 Nov  3 21:10 301-ath9k-limit-retries-for-powersave-response-frames.patch
-rw------- 1 xose xose  4122 Nov  3 21:10 302-ath9k-fix-phyerror-codes.patch
-rw------- 1 xose xose  8493 Nov  3 21:10 303-ath10k-enable-adaptive-CCA.patch
-rw------- 1 xose xose  9188 Nov  3 21:10 304-ath10k-add-FW-API-support-to-test-mode.patch
-rw------- 1 xose xose 14220 Nov  3 21:10 305-ath10k-add-fw_stats-support-to-10.4-firmware.patch
-rw------- 1 xose xose  2173 Nov  3 21:10 306-ath10k-use-local-memory-instead-of-shadow-descriptor.patch
-rw------- 1 xose xose  1195 Nov  3 21:10 307-ath10k-remove-send-completion-validation-in-diag-rea.patch
-rw------- 1 xose xose  5688 Nov  3 21:10 308-ath10k-cleanup-copy-engine-send-completion.patch
-rw------- 1 xose xose  2829 Nov  3 21:10 309-ath10k-remove-shadow-copy-of-CE-descriptors-for-sour.patch
-rw------- 1 xose xose  2474 Nov  3 21:10 310-ath10k-remove-supported-chain-mask.patch
-rw------- 1 xose xose  1305 Nov  3 21:10 311-ath10k-fill-HT-VHT-MCS-rateset-only-for-configured-c.patch
-rw------- 1 xose xose  8563 Nov  3 21:10 312-ath10k-move-static-HT-VHT-capability-setup-functions.patch
-rw------- 1 xose xose  1337 Nov  3 21:10 313-mac80211-fix-crash-on-mesh-local-link-ID-generation-.patch
-rw------- 1 xose xose   795 Nov  3 21:10 400-ath_move_debug_code.patch
-rw------- 1 xose xose   432 Nov  3 21:10 401-ath9k_blink_default.patch
-rw------- 1 xose xose  1562 Nov  3 21:10 402-ath_regd_optional.patch
-rw------- 1 xose xose  2131 Nov  3 21:10 403-world_regd_fixup.patch
-rw------- 1 xose xose   551 Nov  3 21:10 404-regd_no_assoc_hints.patch
-rw------- 1 xose xose   976 Nov  3 21:10 405-ath_regd_us.patch
-rw------- 1 xose xose  1171 Nov  3 21:10 406-ath_relax_default_regd.patch
-rw------- 1 xose xose   391 Nov  3 21:10 410-ath9k_allow_adhoc_and_ap.patch
-rw------- 1 xose xose  1836 Nov  3 21:10 411-ath5k_allow_adhoc_and_ap.patch
-rw------- 1 xose xose   476 Nov  3 21:10 420-ath5k_disable_fast_cc.patch
-rw------- 1 xose xose  1263 Nov  3 21:10 430-add_ath5k_platform.patch
-rw------- 1 xose xose  1398 Nov  3 21:10 431-add_platform_eeprom_support_to_ath5k.patch
-rw------- 1 xose xose   514 Nov  3 21:10 432-ath5k_add_pciids.patch
-rw------- 1 xose xose  4024 Nov  3 21:10 440-ath5k_channel_bw_debugfs.patch
-rw------- 1 xose xose  1718 Nov  3 21:10 500-ath9k_eeprom_debugfs.patch
-rw------- 1 xose xose   650 Nov  3 21:10 501-ath9k_ahb_init.patch
-rw------- 1 xose xose   507 Nov  3 21:10 510-ath9k_intr_mitigation_tweak.patch
-rw------- 1 xose xose   407 Nov  3 21:10 511-ath9k_reduce_rxbuf.patch
-rw------- 1 xose xose  3555 Nov  3 21:10 512-ath9k_channelbw_debugfs.patch
-rw------- 1 xose xose   932 Nov  3 21:10 513-ath9k_add_pci_ids.patch
-rw------- 1 xose xose  5378 Nov  3 21:10 522-mac80211_configure_antenna_gain.patch
-rw------- 1 xose xose  6653 Nov  3 21:10 530-ath9k_extra_leds.patch
-rw------- 1 xose xose  1564 Nov  3 21:10 531-ath9k_extra_platform_leds.patch
-rw------- 1 xose xose   354 Nov  3 21:10 540-ath9k_reduce_ani_interval.patch
-rw------- 1 xose xose   819 Nov  3 21:10 541-ath9k_rx_dma_stop_check.patch
-rw------- 1 xose xose  3967 Nov  3 21:10 542-ath9k_debugfs_diag.patch
-rw------- 1 xose xose  6001 Nov  3 21:10 543-ath9k_entropy_from_adc.patch
-rw------- 1 xose xose  2115 Nov  3 21:10 544-ath9k-ar933x-usb-hang-workaround.patch
-rw------- 1 xose xose  5452 Nov  3 21:10 545-ath9k_ani_ws_detect.patch
-rw------- 1 xose xose  1826 Nov  3 21:10 600-0001-rt2x00-rt2800lib-move-rt2800_drv_data-declaration-in.patch
-rw------- 1 xose xose  2297 Nov  3 21:10 600-0002-rt2x00-rt2800lib-introduce-RT2800_HAS_HIGH_SHARED_ME.patch
-rw------- 1 xose xose 17759 Nov  3 21:10 600-0003-rt2x00-rt2800-serialize-shared-memory-access.patch
-rw------- 1 xose xose  4113 Nov  3 21:10 600-0004-rt2x00-rt2800lib-fix-beacon-generation-on-RT3593.patch
-rw------- 1 xose xose  1967 Nov  3 21:10 600-0005-rt2x00-rt2800lib-add-hw_beacon_count-field-to-struct.patch
-rw------- 1 xose xose  2455 Nov  3 21:10 600-0006-rt2x00-rt2800lib-init-additional-beacon-offset-regis.patch
-rw------- 1 xose xose   821 Nov  3 21:10 600-0007-rt2x00-rt2800lib-fix-max-supported-beacon-count-for-.patch
-rw------- 1 xose xose   933 Nov  3 21:10 600-0008-rt2x00-allow-to-build-rt2800soc-module-for-RT3883.patch
-rw------- 1 xose xose   606 Nov  3 21:10 600-0009-rt2x00-rt2800lib-enable-support-for-RT3883.patch
-rw------- 1 xose xose  2885 Nov  3 21:10 600-0010-rt2x00-rt2800lib-add-rf_vals-for-RF3853.patch
-rw------- 1 xose xose   783 Nov  3 21:10 600-0011-rt2x00-rt2800lib-enable-VCO-calibration-for-RF3853.patch
-rw------- 1 xose xose  6225 Nov  3 21:10 600-0012-rt2x00-rt2800lib-add-channel-configuration-function-.patch
-rw------- 1 xose xose   601 Nov  3 21:10 600-0013-rt2x00-rt2800lib-enable-RF3853-support.patch
-rw------- 1 xose xose  2906 Nov  3 21:10 600-0014-rt2x00-rt2800lib-add-MAC-register-initialization-for.patch
-rw------- 1 xose xose  1000 Nov  3 21:10 600-0015-rt2x00-rt2800soc-fix-rt2800soc_disable_radio-for-RT3.patch
-rw------- 1 xose xose  2302 Nov  3 21:10 600-0016-rt2x00-rt2800lib-add-BBP-register-initialization-for.patch
-rw------- 1 xose xose  6052 Nov  3 21:10 600-0017-rt2x00-rt2800lib-add-RFCSR-initialization-for-RT3883.patch
-rw------- 1 xose xose   771 Nov  3 21:10 600-0018-rt2x00-rt2800lib-use-the-extended-EEPROM-map-for-RT3.patch
-rw------- 1 xose xose   767 Nov  3 21:10 600-0019-rt2x00-rt2800lib-force-rf-type-to-RF3853-on-RT3883.patch
-rw------- 1 xose xose  4325 Nov  3 21:10 600-0020-rt2x00-rt2800lib-add-channel-configuration-code-for-.patch
-rw------- 1 xose xose  1053 Nov  3 21:10 600-0021-rt2x00-rt2800lib-fix-txpower_to_dev-function-for-RT3.patch
-rw------- 1 xose xose   855 Nov  3 21:10 600-0022-rt2x00-rt2800lib-use-correct-txpower-calculation-fun.patch
-rw------- 1 xose xose  1020 Nov  3 21:10 600-0023-rt2x00-rt2800lib-hardcode-txmixer-gain-values-to-zer.patch
-rw------- 1 xose xose   662 Nov  3 21:10 600-0024-rt2x00-rt2800lib-use-correct-RT-XWI-size-for-RT3883.patch
-rw------- 1 xose xose   811 Nov  3 21:10 600-0025-rt2x00-rt2800lib-use-correct-beacon-base-for-RT3883.patch
-rw------- 1 xose xose   820 Nov  3 21:10 600-0026-rt2x00-rt2800lib-use-correct-beacon-count-for-RT3883.patch
-rw------- 1 xose xose   804 Nov  3 21:10 600-0027-rt2x00-rt2800lib-fix-antenna-configuration-for-RT388.patch
-rw------- 1 xose xose  1315 Nov  3 21:10 600-0028-rt2x00-rt2800lib-fix-LNA-gain-configuration-for-RT38.patch
-rw------- 1 xose xose  1434 Nov  3 21:10 600-0029-rt2x00-rt2800lib-fix-VGC-setup-for-RT3883.patch
-rw------- 1 xose xose  1984 Nov  3 21:10 600-0030-rt2x00-rt2800lib-fix-EEPROM-LNA-validation-for-RT388.patch
-rw------- 1 xose xose   762 Nov  3 21:10 600-0031-rt2x00-rt2800lib-fix-txpower-compensation-for-RT3883.patch
-rw------- 1 xose xose   790 Nov  3 21:10 600-0032-rt2x00-rt2800lib-enable-RT2800_HAS_HIGH_SHARED_MEM-f.patch
-rw------- 1 xose xose   754 Nov  3 21:10 600-0033-rt2x00-rt2800lib-use-high-memory-for-beacons-on-RT38.patch
-rw------- 1 xose xose  4107 Nov  3 21:10 600-0034-rt2x00-rt2800mmio-add-a-workaround-for-spurious-TX_F.patch
-rw------- 1 xose xose   395 Nov  3 21:10 601-rt2x00-set_pci_mwi.patch
-rw------- 1 xose xose   796 Nov  3 21:10 602-rt2x00-introduce-rt2x00_platform_h.patch
-rw------- 1 xose xose  8259 Nov  3 21:10 603-rt2x00-introduce-rt2x00eeprom.patch
-rw------- 1 xose xose   820 Nov  3 21:10 604-rt2x00-of_load_eeprom_filename.patch
-rw------- 1 xose xose  2754 Nov  3 21:10 605-rt2x00-load-eeprom-on-SoC-from-a-mtd-device-defines-.patch
-rw------- 1 xose xose  1309 Nov  3 21:10 607-rt2x00-allow_disabling_bands_through_platform_data.patch
-rw------- 1 xose xose  1827 Nov  3 21:10 608-add_platform_data_mac_addr.patch
-rw------- 1 xose xose   915 Nov  3 21:10 609-rt2x00-allow_disabling_bands_through_dts.patch
-rw------- 1 xose xose  7328 Nov  3 21:10 610-rt2x00-fix-rt3352-ext-pa.patch
-rw------- 1 xose xose  2826 Nov  3 21:10 611-rt2x00-rf_vals-rt3352-xtal20.patch
-rw------- 1 xose xose  1049 Nov  3 21:10 612-rt2x00-make-wmac-loadable-via-OF-on-rt288x-305x-SoC.patch
-rw------- 1 xose xose   756 Nov  3 21:10 615-rt2x00-fix_20mhz_clk.patch
-rw------- 1 xose xose  9306 Nov  3 21:10 616-rt2x00-support-rt5350.patch
-rw------- 1 xose xose  1282 Nov  3 21:10 619-rt2x00-change-led-polarity-from-OF.patch
-rw------- 1 xose xose   455 Nov  3 21:10 620-rt2x00-add-AP+STA-support.patch
-rw------- 1 xose xose   570 Nov  3 21:10 620-rt2x00-rt3352-rf-id.patch
-rw------- 1 xose xose  1179 Nov  3 21:10 621-rt2x00-ht20_40_fix.patch
-rw------- 1 xose xose   497 Nov  3 21:10 700-mwl8k-missing-pci-id-for-WNR854T.patch
-rw------- 1 xose xose   565 Nov  3 21:10 801-libertas-configure-sysfs-links.patch
-rw------- 1 xose xose   419 Nov  3 21:10 802-libertas-set-wireless-macaddr.patch
-rw------- 1 xose xose  1369 Nov  3 21:10 805-b43-gpio-mask-module-option.patch
-rw------- 1 xose xose  2201 Nov  3 21:10 810-b43_no_pio.patch
-rw------- 1 xose xose  4105 Nov  3 21:10 820-b43-add-antenna-control.patch
-rw------- 1 xose xose   418 Nov  3 21:10 841-b43-reduce-number-of-RX-slots.patch
-rw------- 1 xose xose   677 Nov  3 21:10 845-b43-only-use-gpio-0-1-for-led.patch
-rw------- 1 xose xose   546 Nov  3 21:10 847-b43-always-take-overlapping-devs.patch
-rw------- 1 xose xose  1199 Nov  3 21:10 850-brcmsmac-remove-extra-regulation-restriction.patch
-rw------- 1 xose xose  2907 Nov  3 21:10 861-brcmfmac-register-wiphy-s-during-module_init.patch
-rw------- 1 xose xose  1832 Nov  3 21:10 862-brcmfmac-workaround-bug-with-some-inconsistent-BSSes.patch
-rw------- 1 xose xose   625 Nov  3 21:10 910-00-rt2x00-enable-rt2800soc-for-mt7620.patch
-rw------- 1 xose xose 43738 Nov  3 21:10 910-01-add-support-for-mt7620.patch
-rw------- 1 xose xose  1226 Nov  3 21:10 921-ath10k_init_devices_synchronously.patch
-rw------- 1 xose xose  1330 Nov  3 21:10 930-ath10k_add_tpt_led_trigger.patch
-rw------- 1 xose xose   493 Nov  3 21:10 940-mwl8k_init_devices_synchronously.patch

and this is _only_ openwrt/package/kernel/mac80211/patches/*

There are a lot of patches missing at upstream.
