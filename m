Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615F7C10F09
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 16:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 351402147A
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 16:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfCHQzC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 11:55:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:58683 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727336AbfCHQzC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 11:55:02 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Mar 2019 08:55:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,456,1544515200"; 
   d="gz'50?scan'50,208,50";a="305562614"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 08 Mar 2019 08:54:59 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1h2Ilu-0001qK-IP; Sat, 09 Mar 2019 00:54:58 +0800
Date:   Sat, 9 Mar 2019 00:54:33 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
Cc:     kbuild-all@01.org, johannes@sipsolutions.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: Re: [PATCHv3 6/9] mac80211: Add api to support configuring TID
 specific configuration
Message-ID: <201903090033.erAosZIT%lkp@intel.com>
References: <1551895251-22941-7-git-send-email-tamizhr@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <1551895251-22941-7-git-send-email-tamizhr@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tamizh,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on next-20190306]
[cannot apply to v5.0]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Tamizh-chelvam/cfg80211-mac80211-Add-support-for-TID-specific-configuration/20190308-195433
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   WARNING: convert(1) not found, for SVG to PDF conversion install ImageMagick (https://www.imagemagick.org)
   include/linux/rcupdate_wait.h:1: warning: no structured comments found
   include/linux/rcutree.h:1: warning: no structured comments found
   kernel/rcu/tree.c:710: warning: Excess function parameter 'irq' description in 'rcu_nmi_exit'
   include/linux/gfp.h:1: warning: no structured comments found
>> include/net/mac80211.h:1639: warning: Function parameter or member 'rate_ctrl' not described in 'ieee80211_vif'
>> include/net/mac80211.h:1639: warning: Function parameter or member 'rate_code' not described in 'ieee80211_vif'
>> include/net/mac80211.h:1639: warning: Function parameter or member 'rtscts' not described in 'ieee80211_vif'
>> include/net/mac80211.h:2008: warning: Function parameter or member 'rate_ctrl' not described in 'ieee80211_sta'
>> include/net/mac80211.h:2008: warning: Function parameter or member 'rtscts' not described in 'ieee80211_sta'
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

vim +1639 include/net/mac80211.h

ddbfe860 Stanislaw Gruszka     2013-03-08  1624  
1b09b556 Andrei Otcheretianski 2015-08-15  1625  	unsigned int probe_req_reg;
1b09b556 Andrei Otcheretianski 2015-08-15  1626  
21a5d4c3 Manikanta Pubbisetty  2018-07-11  1627  	bool txqs_stopped[IEEE80211_NUM_ACS];
21a5d4c3 Manikanta Pubbisetty  2018-07-11  1628  
94e2e2e9 Tamizh chelvam        2019-03-06  1629  	int noack[IEEE80211_TID_MAX];
94e2e2e9 Tamizh chelvam        2019-03-06  1630  	int retry_short[IEEE80211_TID_MAX];
94e2e2e9 Tamizh chelvam        2019-03-06  1631  	int retry_long[IEEE80211_TID_MAX];
94e2e2e9 Tamizh chelvam        2019-03-06  1632  	int ampdu[IEEE80211_TID_MAX];
94e2e2e9 Tamizh chelvam        2019-03-06  1633  	u8 rate_ctrl[IEEE80211_TID_MAX];
94e2e2e9 Tamizh chelvam        2019-03-06  1634  	u32 rate_code[IEEE80211_TID_MAX];
94e2e2e9 Tamizh chelvam        2019-03-06  1635  	u8 rtscts[IEEE80211_TID_MAX];
94e2e2e9 Tamizh chelvam        2019-03-06  1636  
32bfd35d Johannes Berg         2007-12-19  1637  	/* must be last */
1c06ef98 Johannes Berg         2012-12-28  1638  	u8 drv_priv[0] __aligned(sizeof(void *));
32bfd35d Johannes Berg         2007-12-19 @1639  };
32bfd35d Johannes Berg         2007-12-19  1640  

:::::: The code at line 1639 was first introduced by commit
:::::: 32bfd35d4b63bd63de4bb0d791ef049c3c868726 mac80211: dont use interface indices in drivers

:::::: TO: Johannes Berg <johannes@sipsolutions.net>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--45Z9DzgjV8m4Oswq
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
WwAA

--45Z9DzgjV8m4Oswq--
