Return-Path: <SRS0=EMPu=SC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72E2C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Mar 2019 06:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 547122146F
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Mar 2019 06:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbfCaGAg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 31 Mar 2019 02:00:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:56770 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbfCaGAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Mar 2019 02:00:36 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Mar 2019 23:00:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,291,1549958400"; 
   d="gz'50?scan'50,208,50";a="287378062"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 30 Mar 2019 23:00:28 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hATW7-0009Qo-Rx; Sun, 31 Mar 2019 14:00:27 +0800
Date:   Sun, 31 Mar 2019 14:00:18 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Balaji Pothunoori <bpothuno@codeaurora.org>
Cc:     kbuild-all@01.org, johannes@sipsolutions.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: Re: [PATCH v4 1/3] cfg80211: Add support to set tx power for a
 station associated
Message-ID: <201903311346.AArnQvew%lkp@intel.com>
References: <1553856501-21492-1-git-send-email-bpothuno@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1553856501-21492-1-git-send-email-bpothuno@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Balaji,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on v5.1-rc2 next-20190329]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Balaji-Pothunoori/cfg80211-Add-support-to-set-tx-power-for-a-station-associated/20190331-104601
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   WARNING: convert(1) not found, for SVG to PDF conversion install ImageMagick (https://www.imagemagick.org)
   include/linux/rcupdate_wait.h:1: warning: no structured comments found
   include/linux/rcutree.h:1: warning: no structured comments found
   kernel/rcu/tree.c:710: warning: Excess function parameter 'irq' description in 'rcu_nmi_exit'
   include/linux/gfp.h:1: warning: no structured comments found
>> include/net/cfg80211.h:1072: warning: Function parameter or member 'txpwr' not described in 'station_parameters'
   kernel/rcu/tree.c:711: warning: Excess function parameter 'irq' description in 'rcu_nmi_exit'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   include/linux/firmware/intel/stratix10-svc-client.h:1: warning: no structured comments found
   include/linux/gpio/driver.h:371: warning: Function parameter or member 'init_valid_mask' not described in 'gpio_chip'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   include/linux/regulator/machine.h:199: warning: Function parameter or member 'max_uV_step' not described in 'regulation_constraints'
   include/linux/regulator/driver.h:228: warning: Function parameter or member 'resume' not described in 'regulator_ops'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   drivers/slimbus/stream.c:1: warning: no structured comments found
   include/linux/spi/spi.h:180: warning: Function parameter or member 'driver_override' not described in 'spi_device'
   drivers/target/target_core_device.c:1: warning: no structured comments found
   drivers/usb/typec/bus.c:1: warning: no structured comments found
   drivers/usb/typec/class.c:1: warning: no structured comments found
   include/linux/w1.h:281: warning: Function parameter or member 'of_match_table' not described in 'w1_family'
   fs/direct-io.c:257: warning: Excess function parameter 'offset' description in 'dio_complete'
   fs/file_table.c:1: warning: no structured comments found
   fs/libfs.c:477: warning: Excess function parameter 'available' description in 'simple_write_end'
   fs/posix_acl.c:646: warning: Function parameter or member 'inode' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:646: warning: Function parameter or member 'mode_p' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:646: warning: Function parameter or member 'acl' not described in 'posix_acl_update_mode'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:294: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:294: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:294: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:343: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:343: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:343: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:183: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_read_lock'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Function parameter or member 'range' not described in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Function parameter or member 'range' not described in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:382: warning: cannot understand function prototype: 'struct amdgpu_vm_pt_cursor '
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:383: warning: cannot understand function prototype: 'struct amdgpu_vm_pt_cursor '
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'start' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'end' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'entry' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:847: warning: Function parameter or member 'level' not described in 'amdgpu_vm_bo_param'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1352: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1352: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1352: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1352: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1352: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1352: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1352: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1519: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1519: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1519: warning: Function parameter or member 'level' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1519: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1519: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1519: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1519: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1519: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:3095: warning: Function parameter or member 'pasid' not described in 'amdgpu_vm_make_compute'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:128: warning: Incorrect use of kernel-doc format: Documentation Makefile include scripts source @atomic_obj
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'atomic_obj' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'atomic_obj_lock' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'backlight_link' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'backlight_caps' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'freesync_module' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'fw_dmcu' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'dmcu_fw_version' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:1: warning: no structured comments found
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   include/drm/drm_atomic_state_helper.h:1: warning: no structured comments found
   drivers/gpu/drm/drm_dp_helper.c:1364: warning: Function parameter or member 'dsc_dpcd' not described in 'drm_dp_dsc_sink_max_slice_count'
   drivers/gpu/drm/drm_dp_helper.c:1364: warning: Function parameter or member 'is_edp' not described in 'drm_dp_dsc_sink_max_slice_count'
   drivers/gpu/drm/i915/i915_vma.h:49: warning: cannot understand function prototype: 'struct i915_vma '
   drivers/gpu/drm/i915/i915_vma.h:1: warning: no structured comments found
   drivers/gpu/drm/i915/intel_guc_fwif.h:536: warning: cannot understand function prototype: 'struct guc_log_buffer_state '
   drivers/gpu/drm/i915/i915_trace.h:1: warning: no structured comments found
   include/linux/skbuff.h:876: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'list' not described in 'sk_buff'

vim +1072 include/net/cfg80211.h

3b9ce80ce Johannes Berg          2011-09-27   998  
3b9ce80ce Johannes Berg          2011-09-27   999  /**
5727ef1b2 Johannes Berg          2007-12-19  1000   * struct station_parameters - station parameters
5727ef1b2 Johannes Berg          2007-12-19  1001   *
5727ef1b2 Johannes Berg          2007-12-19  1002   * Used to change and create a new station.
5727ef1b2 Johannes Berg          2007-12-19  1003   *
5727ef1b2 Johannes Berg          2007-12-19  1004   * @vlan: vlan interface station should belong to
5727ef1b2 Johannes Berg          2007-12-19  1005   * @supported_rates: supported rates in IEEE 802.11 format
5727ef1b2 Johannes Berg          2007-12-19  1006   *	(or NULL for no change)
5727ef1b2 Johannes Berg          2007-12-19  1007   * @supported_rates_len: number of supported rates
eccb8e8f0 Johannes Berg          2009-05-11  1008   * @sta_flags_mask: station flags that changed
819bf5937 Johannes Berg          2016-10-11  1009   *	(bitmask of BIT(%NL80211_STA_FLAG_...))
eccb8e8f0 Johannes Berg          2009-05-11  1010   * @sta_flags_set: station flags values
819bf5937 Johannes Berg          2016-10-11  1011   *	(bitmask of BIT(%NL80211_STA_FLAG_...))
5727ef1b2 Johannes Berg          2007-12-19  1012   * @listen_interval: listen interval or -1 for no change
5727ef1b2 Johannes Berg          2007-12-19  1013   * @aid: AID or zero for no change
7d27a0ba7 Masashi Honma          2016-07-01  1014   * @peer_aid: mesh peer AID or zero for no change
abe37c4b8 Johannes Berg          2010-06-07  1015   * @plink_action: plink action to take
9c3990aae Javier Cardona         2011-05-03  1016   * @plink_state: set the peer link state for a station
abe37c4b8 Johannes Berg          2010-06-07  1017   * @ht_capa: HT capabilities of station
f461be3ef Mahesh Palivela        2012-10-11  1018   * @vht_capa: VHT capabilities of station
910868db3 Eliad Peller           2011-09-11  1019   * @uapsd_queues: bitmap of queues configured for uapsd. same format
910868db3 Eliad Peller           2011-09-11  1020   *	as the AC bitmap in the QoS info field
910868db3 Eliad Peller           2011-09-11  1021   * @max_sp: max Service Period. same format as the MAX_SP in the
910868db3 Eliad Peller           2011-09-11  1022   *	QoS info field (but already shifted down)
c26887d2a Johannes Berg          2011-11-08  1023   * @sta_modify_mask: bitmap indicating which parameters changed
c26887d2a Johannes Berg          2011-11-08  1024   *	(for those that don't have a natural "no change" value),
c26887d2a Johannes Berg          2011-11-08  1025   *	see &enum station_parameters_apply_mask
3b1c5a530 Marco Porsch           2013-01-07  1026   * @local_pm: local link-specific mesh power save mode (no change when set
3b1c5a530 Marco Porsch           2013-01-07  1027   *	to unknown)
9d62a9861 Jouni Malinen          2013-02-14  1028   * @capability: station capability
9d62a9861 Jouni Malinen          2013-02-14  1029   * @ext_capab: extended capabilities of the station
9d62a9861 Jouni Malinen          2013-02-14  1030   * @ext_capab_len: number of extended capabilities
c01fc9ada Sunil Dutt             2013-10-09  1031   * @supported_channels: supported channels in IEEE 802.11 format
c01fc9ada Sunil Dutt             2013-10-09  1032   * @supported_channels_len: number of supported channels
c01fc9ada Sunil Dutt             2013-10-09  1033   * @supported_oper_classes: supported oper classes in IEEE 802.11 format
c01fc9ada Sunil Dutt             2013-10-09  1034   * @supported_oper_classes_len: number of supported operating classes
60f4a7b16 Marek Kwaczynski       2013-12-03  1035   * @opmode_notif: operating mode field from Operating Mode Notification
60f4a7b16 Marek Kwaczynski       2013-12-03  1036   * @opmode_notif_used: information if operating mode field is used
17b942478 Ayala Beker            2016-03-17  1037   * @support_p2p_ps: information if station supports P2P PS mechanism
c4cbaf797 Luca Coelho            2018-06-09  1038   * @he_capa: HE capabilities of station
c4cbaf797 Luca Coelho            2018-06-09  1039   * @he_capa_len: the length of the HE capabilities
36647055b Toke Høiland-Jørgensen 2018-12-18  1040   * @airtime_weight: airtime scheduler weight for this station
5727ef1b2 Johannes Berg          2007-12-19  1041   */
5727ef1b2 Johannes Berg          2007-12-19  1042  struct station_parameters {
2c1aabf33 Johannes Berg          2013-02-14  1043  	const u8 *supported_rates;
5727ef1b2 Johannes Berg          2007-12-19  1044  	struct net_device *vlan;
eccb8e8f0 Johannes Berg          2009-05-11  1045  	u32 sta_flags_mask, sta_flags_set;
3b9ce80ce Johannes Berg          2011-09-27  1046  	u32 sta_modify_mask;
5727ef1b2 Johannes Berg          2007-12-19  1047  	int listen_interval;
5727ef1b2 Johannes Berg          2007-12-19  1048  	u16 aid;
7d27a0ba7 Masashi Honma          2016-07-01  1049  	u16 peer_aid;
5727ef1b2 Johannes Berg          2007-12-19  1050  	u8 supported_rates_len;
2ec600d67 Luis Carlos Cobo       2008-02-23  1051  	u8 plink_action;
9c3990aae Javier Cardona         2011-05-03  1052  	u8 plink_state;
2c1aabf33 Johannes Berg          2013-02-14  1053  	const struct ieee80211_ht_cap *ht_capa;
2c1aabf33 Johannes Berg          2013-02-14  1054  	const struct ieee80211_vht_cap *vht_capa;
c75786c9e Eliad Peller           2011-08-23  1055  	u8 uapsd_queues;
c75786c9e Eliad Peller           2011-08-23  1056  	u8 max_sp;
3b1c5a530 Marco Porsch           2013-01-07  1057  	enum nl80211_mesh_power_mode local_pm;
9d62a9861 Jouni Malinen          2013-02-14  1058  	u16 capability;
2c1aabf33 Johannes Berg          2013-02-14  1059  	const u8 *ext_capab;
9d62a9861 Jouni Malinen          2013-02-14  1060  	u8 ext_capab_len;
c01fc9ada Sunil Dutt             2013-10-09  1061  	const u8 *supported_channels;
c01fc9ada Sunil Dutt             2013-10-09  1062  	u8 supported_channels_len;
c01fc9ada Sunil Dutt             2013-10-09  1063  	const u8 *supported_oper_classes;
c01fc9ada Sunil Dutt             2013-10-09  1064  	u8 supported_oper_classes_len;
60f4a7b16 Marek Kwaczynski       2013-12-03  1065  	u8 opmode_notif;
60f4a7b16 Marek Kwaczynski       2013-12-03  1066  	bool opmode_notif_used;
17b942478 Ayala Beker            2016-03-17  1067  	int support_p2p_ps;
c4cbaf797 Luca Coelho            2018-06-09  1068  	const struct ieee80211_he_cap_elem *he_capa;
c4cbaf797 Luca Coelho            2018-06-09  1069  	u8 he_capa_len;
36647055b Toke Høiland-Jørgensen 2018-12-18  1070  	u16 airtime_weight;
115e5b332 Ashok Raj Nagarajan    2019-03-29  1071  	struct sta_txpwr txpwr;
5727ef1b2 Johannes Berg          2007-12-19 @1072  };
5727ef1b2 Johannes Berg          2007-12-19  1073  

:::::: The code at line 1072 was first introduced by commit
:::::: 5727ef1b2e797a1922f5bc239b6afb2b4cfb80bc cfg80211/nl80211: station handling

:::::: TO: Johannes Berg <johannes@sipsolutions.net>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--zhXaljGHf11kAtnf
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
AA==

--zhXaljGHf11kAtnf--
