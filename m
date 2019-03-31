Return-Path: <SRS0=EMPu=SC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B270BC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Mar 2019 07:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FC452146F
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Mar 2019 07:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfCaHWj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 31 Mar 2019 03:22:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:47049 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbfCaHWi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Mar 2019 03:22:38 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Mar 2019 00:22:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,291,1549958400"; 
   d="gz'50?scan'50,208,50";a="287388846"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 31 Mar 2019 00:22:29 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hAUnU-000ERT-UD; Sun, 31 Mar 2019 15:22:28 +0800
Date:   Sun, 31 Mar 2019 15:22:10 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Balaji Pothunoori <bpothuno@codeaurora.org>
Cc:     kbuild-all@01.org, johannes@sipsolutions.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: Re: [PATCH v4 2/3] mac80211: store tx power value from user to
 station
Message-ID: <201903311552.TtxO16s6%lkp@intel.com>
References: <1553856549-21552-1-git-send-email-bpothuno@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1553856549-21552-1-git-send-email-bpothuno@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=utf-8
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
   include/net/cfg80211.h:1072: warning: Function parameter or member 'txpwr' not described in 'station_parameters'
>> include/net/mac80211.h:4029: warning: Function parameter or member 'sta_set_txpwr' not described in 'ieee80211_ops'
>> include/net/mac80211.h:2000: warning: Function parameter or member 'txpwr' not described in 'ieee80211_sta'
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

vim +4029 include/net/mac80211.h

cf2c92d840 Eliad Peller           2014-11-04  3188  
cf2c92d840 Eliad Peller           2014-11-04  3189  /**
75a5f0ccfd Johannes Berg          2007-09-18  3190   * struct ieee80211_ops - callbacks from mac80211 to the driver
75a5f0ccfd Johannes Berg          2007-09-18  3191   *
75a5f0ccfd Johannes Berg          2007-09-18  3192   * This structure contains various callbacks that the driver may
75a5f0ccfd Johannes Berg          2007-09-18  3193   * handle or, in some cases, must handle, for example to configure
75a5f0ccfd Johannes Berg          2007-09-18  3194   * the hardware to a new channel or to transmit a frame.
75a5f0ccfd Johannes Berg          2007-09-18  3195   *
75a5f0ccfd Johannes Berg          2007-09-18  3196   * @tx: Handler that 802.11 module calls for each transmitted frame.
f0706e828e Jiri Benc              2007-05-05  3197   *	skb contains the buffer starting from the IEEE 802.11 header.
f0706e828e Jiri Benc              2007-05-05  3198   *	The low-level driver should send the frame out based on
eefce91a38 Johannes Berg          2008-05-17  3199   *	configuration in the TX control data. This handler should,
11127e9121 Johannes Berg          2011-11-16  3200   *	preferably, never fail and stop queues appropriately.
11127e9121 Johannes Berg          2011-11-16  3201   *	Must be atomic.
75a5f0ccfd Johannes Berg          2007-09-18  3202   *
75a5f0ccfd Johannes Berg          2007-09-18  3203   * @start: Called before the first netdevice attached to the hardware
4150c57212 Johannes Berg          2007-09-17  3204   *	is enabled. This should turn on the hardware and must turn on
4150c57212 Johannes Berg          2007-09-17  3205   *	frame reception (for possibly enabled monitor interfaces.)
4150c57212 Johannes Berg          2007-09-17  3206   *	Returns negative error codes, these may be seen in userspace,
4150c57212 Johannes Berg          2007-09-17  3207   *	or zero.
4150c57212 Johannes Berg          2007-09-17  3208   *	When the device is started it should not have a MAC address
4150c57212 Johannes Berg          2007-09-17  3209   *	to avoid acknowledging frames before a non-monitor device
4150c57212 Johannes Berg          2007-09-17  3210   *	is added.
e1781ed33a Kalle Valo             2009-12-23  3211   *	Must be implemented and can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3212   *
75a5f0ccfd Johannes Berg          2007-09-18  3213   * @stop: Called after last netdevice attached to the hardware
4150c57212 Johannes Berg          2007-09-17  3214   *	is disabled. This should turn off the hardware (at least
4150c57212 Johannes Berg          2007-09-17  3215   *	it must turn off frame reception.)
4150c57212 Johannes Berg          2007-09-17  3216   *	May be called right after add_interface if that rejects
42935ecaf4 Luis R. Rodriguez      2009-07-29  3217   *	an interface. If you added any work onto the mac80211 workqueue
42935ecaf4 Luis R. Rodriguez      2009-07-29  3218   *	you should ensure to cancel it on this callback.
e1781ed33a Kalle Valo             2009-12-23  3219   *	Must be implemented and can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3220   *
eecc48000a Johannes Berg          2011-05-04  3221   * @suspend: Suspend the device; mac80211 itself will quiesce before and
eecc48000a Johannes Berg          2011-05-04  3222   *	stop transmitting and doing any other configuration, and then
eecc48000a Johannes Berg          2011-05-04  3223   *	ask the device to suspend. This is only invoked when WoWLAN is
eecc48000a Johannes Berg          2011-05-04  3224   *	configured, otherwise the device is deconfigured completely and
eecc48000a Johannes Berg          2011-05-04  3225   *	reconfigured at resume time.
2b4562dfd6 Johannes Berg          2011-07-02  3226   *	The driver may also impose special conditions under which it
2b4562dfd6 Johannes Berg          2011-07-02  3227   *	wants to use the "normal" suspend (deconfigure), say if it only
2b4562dfd6 Johannes Berg          2011-07-02  3228   *	supports WoWLAN when the device is associated. In this case, it
2b4562dfd6 Johannes Berg          2011-07-02  3229   *	must return 1 from this function.
eecc48000a Johannes Berg          2011-05-04  3230   *
eecc48000a Johannes Berg          2011-05-04  3231   * @resume: If WoWLAN was configured, this indicates that mac80211 is
eecc48000a Johannes Berg          2011-05-04  3232   *	now resuming its operation, after this the device must be fully
eecc48000a Johannes Berg          2011-05-04  3233   *	functional again. If this returns an error, the only way out is
eecc48000a Johannes Berg          2011-05-04  3234   *	to also unregister the device. If it returns 1, then mac80211
eecc48000a Johannes Berg          2011-05-04  3235   *	will also go through the regular complete restart on resume.
eecc48000a Johannes Berg          2011-05-04  3236   *
d13e141481 Johannes Berg          2012-06-09  3237   * @set_wakeup: Enable or disable wakeup when WoWLAN configuration is
d13e141481 Johannes Berg          2012-06-09  3238   *	modified. The reason is that device_set_wakeup_enable() is
d13e141481 Johannes Berg          2012-06-09  3239   *	supposed to be called when the configuration changes, not only
d13e141481 Johannes Berg          2012-06-09  3240   *	in suspend().
d13e141481 Johannes Berg          2012-06-09  3241   *
75a5f0ccfd Johannes Berg          2007-09-18  3242   * @add_interface: Called when a netdevice attached to the hardware is
e37d4dffdf Bob Copeland           2008-10-20  3243   *	enabled. Because it is not called for monitor mode devices, @start
75a5f0ccfd Johannes Berg          2007-09-18  3244   *	and @stop must be implemented.
4150c57212 Johannes Berg          2007-09-17  3245   *	The driver should perform any initialization it needs before
4150c57212 Johannes Berg          2007-09-17  3246   *	the device can be enabled. The initial configuration for the
4150c57212 Johannes Berg          2007-09-17  3247   *	interface is given in the conf parameter.
75a5f0ccfd Johannes Berg          2007-09-18  3248   *	The callback may refuse to add an interface by returning a
75a5f0ccfd Johannes Berg          2007-09-18  3249   *	negative error code (which will be seen in userspace.)
e1781ed33a Kalle Valo             2009-12-23  3250   *	Must be implemented and can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3251   *
34d4bc4d41 Johannes Berg          2010-08-27  3252   * @change_interface: Called when a netdevice changes type. This callback
34d4bc4d41 Johannes Berg          2010-08-27  3253   *	is optional, but only if it is supported can interface types be
34d4bc4d41 Johannes Berg          2010-08-27  3254   *	switched while the interface is UP. The callback may sleep.
34d4bc4d41 Johannes Berg          2010-08-27  3255   *	Note that while an interface is being switched, it will not be
34d4bc4d41 Johannes Berg          2010-08-27  3256   *	found by the interface iteration callbacks.
34d4bc4d41 Johannes Berg          2010-08-27  3257   *
75a5f0ccfd Johannes Berg          2007-09-18  3258   * @remove_interface: Notifies a driver that an interface is going down.
75a5f0ccfd Johannes Berg          2007-09-18  3259   *	The @stop callback is called after this if it is the last interface
75a5f0ccfd Johannes Berg          2007-09-18  3260   *	and no monitor interfaces are present.
4150c57212 Johannes Berg          2007-09-17  3261   *	When all interfaces are removed, the MAC address in the hardware
4150c57212 Johannes Berg          2007-09-17  3262   *	must be cleared so the device no longer acknowledges packets,
4150c57212 Johannes Berg          2007-09-17  3263   *	the mac_addr member of the conf structure is, however, set to the
4150c57212 Johannes Berg          2007-09-17  3264   *	MAC address of the device going away.
e1781ed33a Kalle Valo             2009-12-23  3265   *	Hence, this callback must be implemented. It can sleep.
4150c57212 Johannes Berg          2007-09-17  3266   *
75a5f0ccfd Johannes Berg          2007-09-18  3267   * @config: Handler for configuration requests. IEEE 802.11 code calls this
75a5f0ccfd Johannes Berg          2007-09-18  3268   *	function to change hardware configuration, e.g., channel.
6dd1bf3118 Bob Copeland           2009-01-08  3269   *	This function should never fail but returns a negative error code
e1781ed33a Kalle Valo             2009-12-23  3270   *	if it does. The callback can sleep.
4150c57212 Johannes Berg          2007-09-17  3271   *
471b3efdfc Johannes Berg          2007-12-28  3272   * @bss_info_changed: Handler for configuration requests related to BSS
471b3efdfc Johannes Berg          2007-12-28  3273   *	parameters that may vary during BSS's lifespan, and may affect low
471b3efdfc Johannes Berg          2007-12-28  3274   *	level driver (e.g. assoc/disassoc status, erp parameters).
471b3efdfc Johannes Berg          2007-12-28  3275   *	This function should not be used if no BSS has been set, unless
471b3efdfc Johannes Berg          2007-12-28  3276   *	for association indication. The @changed parameter indicates which
e1781ed33a Kalle Valo             2009-12-23  3277   *	of the bss parameters has changed when a call is made. The callback
e1781ed33a Kalle Valo             2009-12-23  3278   *	can sleep.
471b3efdfc Johannes Berg          2007-12-28  3279   *
3ac64beecd Johannes Berg          2009-08-17  3280   * @prepare_multicast: Prepare for multicast filter configuration.
3ac64beecd Johannes Berg          2009-08-17  3281   *	This callback is optional, and its return value is passed
3ac64beecd Johannes Berg          2009-08-17  3282   *	to configure_filter(). This callback must be atomic.
3ac64beecd Johannes Berg          2009-08-17  3283   *
75a5f0ccfd Johannes Berg          2007-09-18  3284   * @configure_filter: Configure the device's RX filter.
75a5f0ccfd Johannes Berg          2007-09-18  3285   *	See the section "Frame filtering" for more information.
e1781ed33a Kalle Valo             2009-12-23  3286   *	This callback must be implemented and can sleep.
8f20fc2498 Johannes Berg          2007-08-28  3287   *
1b09b5568e Andrei Otcheretianski  2015-08-15  3288   * @config_iface_filter: Configure the interface's RX filter.
1b09b5568e Andrei Otcheretianski  2015-08-15  3289   *	This callback is optional and is used to configure which frames
1b09b5568e Andrei Otcheretianski  2015-08-15  3290   *	should be passed to mac80211. The filter_flags is the combination
1b09b5568e Andrei Otcheretianski  2015-08-15  3291   *	of FIF_* flags. The changed_flags is a bit mask that indicates
1b09b5568e Andrei Otcheretianski  2015-08-15  3292   *	which flags are changed.
1b09b5568e Andrei Otcheretianski  2015-08-15  3293   *	This callback can sleep.
1b09b5568e Andrei Otcheretianski  2015-08-15  3294   *
546c80c91f Luis R. Rodriguez      2008-08-14  3295   * @set_tim: Set TIM bit. mac80211 calls this function when a TIM bit
17741cdc26 Johannes Berg          2008-09-11  3296   * 	must be set or cleared for a given STA. Must be atomic.
11a843b7e1 Johannes Berg          2007-08-28  3297   *
75a5f0ccfd Johannes Berg          2007-09-18  3298   * @set_key: See the section "Hardware crypto acceleration"
e1781ed33a Kalle Valo             2009-12-23  3299   *	This callback is only called between add_interface and
e1781ed33a Kalle Valo             2009-12-23  3300   *	remove_interface calls, i.e. while the given virtual interface
dc822b5db4 Johannes Berg          2008-12-29  3301   *	is enabled.
6dd1bf3118 Bob Copeland           2009-01-08  3302   *	Returns a negative error code if the key can't be added.
e1781ed33a Kalle Valo             2009-12-23  3303   *	The callback can sleep.
11a843b7e1 Johannes Berg          2007-08-28  3304   *
9ae4fda332 Emmanuel Grumbach      2008-03-20  3305   * @update_tkip_key: See the section "Hardware crypto acceleration"
9ae4fda332 Emmanuel Grumbach      2008-03-20  3306   * 	This callback will be called in the context of Rx. Called for drivers
9ae4fda332 Emmanuel Grumbach      2008-03-20  3307   * 	which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
eb807fb238 Kalle Valo             2010-01-24  3308   *	The callback must be atomic.
9ae4fda332 Emmanuel Grumbach      2008-03-20  3309   *
c68f4b892c Johannes Berg          2011-07-05  3310   * @set_rekey_data: If the device supports GTK rekeying, for example while the
c68f4b892c Johannes Berg          2011-07-05  3311   *	host is suspended, it can assign this callback to retrieve the data
c68f4b892c Johannes Berg          2011-07-05  3312   *	necessary to do GTK rekeying, this is the KEK, KCK and replay counter.
c68f4b892c Johannes Berg          2011-07-05  3313   *	After rekeying was done it should (for example during resume) notify
c68f4b892c Johannes Berg          2011-07-05  3314   *	userspace of the new replay counter using ieee80211_gtk_rekey_notify().
c68f4b892c Johannes Berg          2011-07-05  3315   *
de5fad8157 Yoni Divinsky          2012-05-30  3316   * @set_default_unicast_key: Set the default (unicast) key index, useful for
de5fad8157 Yoni Divinsky          2012-05-30  3317   *	WEP when the device sends data packets autonomously, e.g. for ARP
de5fad8157 Yoni Divinsky          2012-05-30  3318   *	offloading. The index can be 0-3, or -1 for unsetting it.
de5fad8157 Yoni Divinsky          2012-05-30  3319   *
75a5f0ccfd Johannes Berg          2007-09-18  3320   * @hw_scan: Ask the hardware to service the scan request, no need to start
8318d78a44 Johannes Berg          2008-01-24  3321   *	the scan state machine in stack. The scan must honour the channel
9050bdd858 Kalle Valo             2009-03-22  3322   *	configuration done by the regulatory agent in the wiphy's
9050bdd858 Kalle Valo             2009-03-22  3323   *	registered bands. The hardware (or the driver) needs to make sure
de95a54b1a Johannes Berg          2009-04-01  3324   *	that power save is disabled.
de95a54b1a Johannes Berg          2009-04-01  3325   *	The @req ie/ie_len members are rewritten by mac80211 to contain the
de95a54b1a Johannes Berg          2009-04-01  3326   *	entire IEs after the SSID, so that drivers need not look at these
de95a54b1a Johannes Berg          2009-04-01  3327   *	at all but just send them after the SSID -- mac80211 includes the
de95a54b1a Johannes Berg          2009-04-01  3328   *	(extended) supported rates and HT information (where applicable).
de95a54b1a Johannes Berg          2009-04-01  3329   *	When the scan finishes, ieee80211_scan_completed() must be called;
de95a54b1a Johannes Berg          2009-04-01  3330   *	note that it also must be called when the scan cannot finish due to
de95a54b1a Johannes Berg          2009-04-01  3331   *	any error unless this callback returned a negative error code.
e9da68ddea Johannes Berg          2018-10-18  3332   *	This callback is also allowed to return the special return value 1,
e9da68ddea Johannes Berg          2018-10-18  3333   *	this indicates that hardware scan isn't desirable right now and a
e9da68ddea Johannes Berg          2018-10-18  3334   *	software scan should be done instead. A driver wishing to use this
e9da68ddea Johannes Berg          2018-10-18  3335   *	capability must ensure its (hardware) scan capabilities aren't
e9da68ddea Johannes Berg          2018-10-18  3336   *	advertised as more capable than mac80211's software scan is.
e1781ed33a Kalle Valo             2009-12-23  3337   *	The callback can sleep.
11a843b7e1 Johannes Berg          2007-08-28  3338   *
b856439b1b Eliad Peller           2011-06-13  3339   * @cancel_hw_scan: Ask the low-level tp cancel the active hw scan.
b856439b1b Eliad Peller           2011-06-13  3340   *	The driver should ask the hardware to cancel the scan (if possible),
b856439b1b Eliad Peller           2011-06-13  3341   *	but the scan will be completed only after the driver will call
b856439b1b Eliad Peller           2011-06-13  3342   *	ieee80211_scan_completed().
b856439b1b Eliad Peller           2011-06-13  3343   *	This callback is needed for wowlan, to prevent enqueueing a new
b856439b1b Eliad Peller           2011-06-13  3344   *	scan_work after the low-level driver was already suspended.
b856439b1b Eliad Peller           2011-06-13  3345   *	The callback can sleep.
b856439b1b Eliad Peller           2011-06-13  3346   *
79f460ca49 Luciano Coelho         2011-05-11  3347   * @sched_scan_start: Ask the hardware to start scanning repeatedly at
79f460ca49 Luciano Coelho         2011-05-11  3348   *	specific intervals.  The driver must call the
79f460ca49 Luciano Coelho         2011-05-11  3349   *	ieee80211_sched_scan_results() function whenever it finds results.
79f460ca49 Luciano Coelho         2011-05-11  3350   *	This process will continue until sched_scan_stop is called.
79f460ca49 Luciano Coelho         2011-05-11  3351   *
79f460ca49 Luciano Coelho         2011-05-11  3352   * @sched_scan_stop: Tell the hardware to stop an ongoing scheduled scan.
37e3308cb2 Johannes Berg          2014-02-17  3353   *	In this case, ieee80211_sched_scan_stopped() must not be called.
79f460ca49 Luciano Coelho         2011-05-11  3354   *
80e775bf08 Michael Buesch         2009-02-20  3355   * @sw_scan_start: Notifier function that is called just before a software scan
80e775bf08 Michael Buesch         2009-02-20  3356   *	is started. Can be NULL, if the driver doesn't need this notification.
a344d6778a Johannes Berg          2014-06-12  3357   *	The mac_addr parameter allows supporting NL80211_SCAN_FLAG_RANDOM_ADDR,
a344d6778a Johannes Berg          2014-06-12  3358   *	the driver may set the NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR flag if it
a344d6778a Johannes Berg          2014-06-12  3359   *	can use this parameter. The callback can sleep.
80e775bf08 Michael Buesch         2009-02-20  3360   *
e1781ed33a Kalle Valo             2009-12-23  3361   * @sw_scan_complete: Notifier function that is called just after a
e1781ed33a Kalle Valo             2009-12-23  3362   *	software scan finished. Can be NULL, if the driver doesn't need
e1781ed33a Kalle Valo             2009-12-23  3363   *	this notification.
e1781ed33a Kalle Valo             2009-12-23  3364   *	The callback can sleep.
80e775bf08 Michael Buesch         2009-02-20  3365   *
6dd1bf3118 Bob Copeland           2009-01-08  3366   * @get_stats: Return low-level statistics.
6dd1bf3118 Bob Copeland           2009-01-08  3367   * 	Returns zero if statistics are available.
e1781ed33a Kalle Valo             2009-12-23  3368   *	The callback can sleep.
7ac1bd6aec Johannes Berg          2007-09-14  3369   *
9352c19f63 Johannes Berg          2015-04-20  3370   * @get_key_seq: If your device implements encryption in hardware and does
9352c19f63 Johannes Berg          2015-04-20  3371   *	IV/PN assignment then this callback should be provided to read the
9352c19f63 Johannes Berg          2015-04-20  3372   *	IV/PN for the given key from hardware.
e1781ed33a Kalle Valo             2009-12-23  3373   *	The callback must be atomic.
75a5f0ccfd Johannes Berg          2007-09-18  3374   *
f23a478075 Arik Nemtsov           2010-11-08  3375   * @set_frag_threshold: Configuration of fragmentation threshold. Assign this
f3fe4e93dd Sara Sharon            2016-10-18  3376   *	if the device does fragmentation by itself. Note that to prevent the
f3fe4e93dd Sara Sharon            2016-10-18  3377   *	stack from doing fragmentation IEEE80211_HW_SUPPORTS_TX_FRAG
f3fe4e93dd Sara Sharon            2016-10-18  3378   *	should be set as well.
f23a478075 Arik Nemtsov           2010-11-08  3379   *	The callback can sleep.
f23a478075 Arik Nemtsov           2010-11-08  3380   *
75a5f0ccfd Johannes Berg          2007-09-18  3381   * @set_rts_threshold: Configuration of RTS threshold (if device needs it)
e1781ed33a Kalle Valo             2009-12-23  3382   *	The callback can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3383   *
34e895075e Johannes Berg          2010-02-03  3384   * @sta_add: Notifies low level driver about addition of an associated station,
34e895075e Johannes Berg          2010-02-03  3385   *	AP, IBSS/WDS/mesh peer etc. This callback can sleep.
34e895075e Johannes Berg          2010-02-03  3386   *
34e895075e Johannes Berg          2010-02-03  3387   * @sta_remove: Notifies low level driver about removal of an associated
6a9d1b91f3 Johannes Berg          2013-12-04  3388   *	station, AP, IBSS/WDS/mesh peer etc. Note that after the callback
6a9d1b91f3 Johannes Berg          2013-12-04  3389   *	returns it isn't safe to use the pointer, not even RCU protected;
6a9d1b91f3 Johannes Berg          2013-12-04  3390   *	no RCU grace period is guaranteed between returning here and freeing
6a9d1b91f3 Johannes Berg          2013-12-04  3391   *	the station. See @sta_pre_rcu_remove if needed.
6a9d1b91f3 Johannes Berg          2013-12-04  3392   *	This callback can sleep.
34e895075e Johannes Berg          2010-02-03  3393   *
77d2ece6fd Sujith Manoharan       2012-11-20  3394   * @sta_add_debugfs: Drivers can use this callback to add debugfs files
77d2ece6fd Sujith Manoharan       2012-11-20  3395   *	when a station is added to mac80211's station list. This callback
c7e9dbcf09 Johannes Berg          2016-09-14  3396   *	should be within a CONFIG_MAC80211_DEBUGFS conditional. This
c7e9dbcf09 Johannes Berg          2016-09-14  3397   *	callback can sleep.
77d2ece6fd Sujith Manoharan       2012-11-20  3398   *
34e895075e Johannes Berg          2010-02-03  3399   * @sta_notify: Notifies low level driver about power state transition of an
d057e5a381 Arik Nemtsov           2011-01-31  3400   *	associated station, AP,  IBSS/WDS/mesh peer etc. For a VIF operating
d057e5a381 Arik Nemtsov           2011-01-31  3401   *	in AP mode, this callback will not be called when the flag
d057e5a381 Arik Nemtsov           2011-01-31  3402   *	%IEEE80211_HW_AP_LINK_PS is set. Must be atomic.
4571d3bf87 Christian Lamparter    2008-11-30  3403   *
f09603a259 Johannes Berg          2012-01-20  3404   * @sta_state: Notifies low level driver about state transition of a
f09603a259 Johannes Berg          2012-01-20  3405   *	station (which can be the AP, a client, IBSS/WDS/mesh peer etc.)
f09603a259 Johannes Berg          2012-01-20  3406   *	This callback is mutually exclusive with @sta_add/@sta_remove.
f09603a259 Johannes Berg          2012-01-20  3407   *	It must not fail for down transitions but may fail for transitions
6a9d1b91f3 Johannes Berg          2013-12-04  3408   *	up the list of states. Also note that after the callback returns it
6a9d1b91f3 Johannes Berg          2013-12-04  3409   *	isn't safe to use the pointer, not even RCU protected - no RCU grace
6a9d1b91f3 Johannes Berg          2013-12-04  3410   *	period is guaranteed between returning here and freeing the station.
6a9d1b91f3 Johannes Berg          2013-12-04  3411   *	See @sta_pre_rcu_remove if needed.
6a9d1b91f3 Johannes Berg          2013-12-04  3412   *	The callback can sleep.
6a9d1b91f3 Johannes Berg          2013-12-04  3413   *
6a9d1b91f3 Johannes Berg          2013-12-04  3414   * @sta_pre_rcu_remove: Notify driver about station removal before RCU
6a9d1b91f3 Johannes Berg          2013-12-04  3415   *	synchronisation. This is useful if a driver needs to have station
6a9d1b91f3 Johannes Berg          2013-12-04  3416   *	pointers protected using RCU, it can then use this call to clear
6a9d1b91f3 Johannes Berg          2013-12-04  3417   *	the pointers instead of waiting for an RCU grace period to elapse
6a9d1b91f3 Johannes Berg          2013-12-04  3418   *	in @sta_state.
f09603a259 Johannes Berg          2012-01-20  3419   *	The callback can sleep.
f09603a259 Johannes Berg          2012-01-20  3420   *
8f727ef3c4 Johannes Berg          2012-03-30  3421   * @sta_rc_update: Notifies the driver of changes to the bitrates that can be
8f727ef3c4 Johannes Berg          2012-03-30  3422   *	used to transmit to the station. The changes are advertised with bits
8f727ef3c4 Johannes Berg          2012-03-30  3423   *	from &enum ieee80211_rate_control_changed and the values are reflected
8f727ef3c4 Johannes Berg          2012-03-30  3424   *	in the station data. This callback should only be used when the driver
8f727ef3c4 Johannes Berg          2012-03-30  3425   *	uses hardware rate control (%IEEE80211_HW_HAS_RATE_CONTROL) since
8f727ef3c4 Johannes Berg          2012-03-30  3426   *	otherwise the rate control algorithm is notified directly.
8f727ef3c4 Johannes Berg          2012-03-30  3427   *	Must be atomic.
f815e2b3c0 Johannes Berg          2014-11-19  3428   * @sta_rate_tbl_update: Notifies the driver that the rate table changed. This
f815e2b3c0 Johannes Berg          2014-11-19  3429   *	is only used if the configured rate control algorithm actually uses
f815e2b3c0 Johannes Berg          2014-11-19  3430   *	the new rate table API, and is therefore optional. Must be atomic.
8f727ef3c4 Johannes Berg          2012-03-30  3431   *
2b9a7e1bac Johannes Berg          2014-11-17  3432   * @sta_statistics: Get statistics for this station. For example with beacon
2b9a7e1bac Johannes Berg          2014-11-17  3433   *	filtering, the statistics kept by mac80211 might not be accurate, so
2b9a7e1bac Johannes Berg          2014-11-17  3434   *	let the driver pre-fill the statistics. The driver can fill most of
2b9a7e1bac Johannes Berg          2014-11-17  3435   *	the values (indicating which by setting the filled bitmap), but not
2b9a7e1bac Johannes Berg          2014-11-17  3436   *	all of them make sense - see the source for which ones are possible.
2b9a7e1bac Johannes Berg          2014-11-17  3437   *	Statistics that the driver doesn't fill will be filled by mac80211.
2b9a7e1bac Johannes Berg          2014-11-17  3438   *	The callback can sleep.
2b9a7e1bac Johannes Berg          2014-11-17  3439   *
75a5f0ccfd Johannes Berg          2007-09-18  3440   * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
fe3fa82731 Johannes Berg          2008-09-08  3441   *	bursting) for a hardware TX queue.
6dd1bf3118 Bob Copeland           2009-01-08  3442   *	Returns a negative error code on failure.
e1781ed33a Kalle Valo             2009-12-23  3443   *	The callback can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3444   *
75a5f0ccfd Johannes Berg          2007-09-18  3445   * @get_tsf: Get the current TSF timer value from firmware/hardware. Currently,
3b5d665b51 Alina Friedrichsen     2009-01-24  3446   *	this is only used for IBSS mode BSSID merging and debugging. Is not a
7b08b3b4a9 Alina Friedrichsen     2009-02-05  3447   *	required function.
e1781ed33a Kalle Valo             2009-12-23  3448   *	The callback can sleep.
3b5d665b51 Alina Friedrichsen     2009-01-24  3449   *
3b5d665b51 Alina Friedrichsen     2009-01-24  3450   * @set_tsf: Set the TSF timer to the specified value in the firmware/hardware.
3b5d665b51 Alina Friedrichsen     2009-01-24  3451   *	Currently, this is only used for IBSS mode debugging. Is not a
7b08b3b4a9 Alina Friedrichsen     2009-02-05  3452   *	required function.
e1781ed33a Kalle Valo             2009-12-23  3453   *	The callback can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3454   *
354d381baf Pedersen, Thomas       2016-09-28  3455   * @offset_tsf: Offset the TSF timer by the specified value in the
354d381baf Pedersen, Thomas       2016-09-28  3456   *	firmware/hardware.  Preferred to set_tsf as it avoids delay between
354d381baf Pedersen, Thomas       2016-09-28  3457   *	calling set_tsf() and hardware getting programmed, which will show up
354d381baf Pedersen, Thomas       2016-09-28  3458   *	as TSF delay. Is not a required function.
354d381baf Pedersen, Thomas       2016-09-28  3459   *	The callback can sleep.
354d381baf Pedersen, Thomas       2016-09-28  3460   *
75a5f0ccfd Johannes Berg          2007-09-18  3461   * @reset_tsf: Reset the TSF timer and allow firmware/hardware to synchronize
75a5f0ccfd Johannes Berg          2007-09-18  3462   *	with other STAs in the IBSS. This is only used in IBSS mode. This
75a5f0ccfd Johannes Berg          2007-09-18  3463   *	function is optional if the firmware/hardware takes full care of
75a5f0ccfd Johannes Berg          2007-09-18  3464   *	TSF synchronization.
e1781ed33a Kalle Valo             2009-12-23  3465   *	The callback can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3466   *
75a5f0ccfd Johannes Berg          2007-09-18  3467   * @tx_last_beacon: Determine whether the last IBSS beacon was sent by us.
75a5f0ccfd Johannes Berg          2007-09-18  3468   *	This is needed only for IBSS mode and the result of this function is
75a5f0ccfd Johannes Berg          2007-09-18  3469   *	used to determine whether to reply to Probe Requests.
6dd1bf3118 Bob Copeland           2009-01-08  3470   *	Returns non-zero if this device sent the last beacon.
e1781ed33a Kalle Valo             2009-12-23  3471   *	The callback can sleep.
d3c990fb26 Ron Rindjunsky         2007-11-26  3472   *
4e8998f09b Randy Dunlap           2010-05-21  3473   * @get_survey: Return per-channel survey information
4e8998f09b Randy Dunlap           2010-05-21  3474   *
1f87f7d3a3 Johannes Berg          2009-06-02  3475   * @rfkill_poll: Poll rfkill hardware state. If you need this, you also
1f87f7d3a3 Johannes Berg          2009-06-02  3476   *	need to set wiphy->rfkill_poll to %true before registration,
1f87f7d3a3 Johannes Berg          2009-06-02  3477   *	and need to call wiphy_rfkill_set_hw_state() in the callback.
e1781ed33a Kalle Valo             2009-12-23  3478   *	The callback can sleep.
aff89a9b90 Johannes Berg          2009-07-01  3479   *
310bc676e3 Lukáš Turek            2009-12-21  3480   * @set_coverage_class: Set slot time for given coverage class as specified
310bc676e3 Lukáš Turek            2009-12-21  3481   *	in IEEE 802.11-2007 section 17.3.8.6 and modify ACK timeout
a4bcaf5556 Lorenzo Bianconi       2014-09-04  3482   *	accordingly; coverage class equals to -1 to enable ACK timeout
a4bcaf5556 Lorenzo Bianconi       2014-09-04  3483   *	estimation algorithm (dynack). To disable dynack set valid value for
a4bcaf5556 Lorenzo Bianconi       2014-09-04  3484   *	coverage class. This callback is not required and may sleep.
310bc676e3 Lukáš Turek            2009-12-21  3485   *
52981cd794 David Spinadel         2013-07-31  3486   * @testmode_cmd: Implement a cfg80211 test mode command. The passed @vif may
52981cd794 David Spinadel         2013-07-31  3487   *	be %NULL. The callback can sleep.
71063f0e89 Wey-Yi Guy             2011-05-20  3488   * @testmode_dump: Implement a cfg80211 test mode dump. The callback can sleep.
a80f7c0b08 Johannes Berg          2009-12-23  3489   *
a80f7c0b08 Johannes Berg          2009-12-23  3490   * @flush: Flush all pending frames from the hardware queue, making sure
39ecc01d1b Johannes Berg          2013-02-13  3491   *	that the hardware queues are empty. The @queues parameter is a bitmap
39ecc01d1b Johannes Berg          2013-02-13  3492   *	of queues to flush, which is useful if different virtual interfaces
39ecc01d1b Johannes Berg          2013-02-13  3493   *	use different hardware queues; it may also indicate all queues.
39ecc01d1b Johannes Berg          2013-02-13  3494   *	If the parameter @drop is set to %true, pending frames may be dropped.
77be2c54c5 Emmanuel Grumbach      2014-03-27  3495   *	Note that vif can be NULL.
39ecc01d1b Johannes Berg          2013-02-13  3496   *	The callback can sleep.
5ce6e438d5 Johannes Berg          2010-05-11  3497   *
5ce6e438d5 Johannes Berg          2010-05-11  3498   * @channel_switch: Drivers that need (or want) to offload the channel
5ce6e438d5 Johannes Berg          2010-05-11  3499   *	switch operation for CSAs received from the AP may implement this
5ce6e438d5 Johannes Berg          2010-05-11  3500   *	callback. They must then call ieee80211_chswitch_done() to indicate
5ce6e438d5 Johannes Berg          2010-05-11  3501   *	completion of the channel switch.
4e6cbfd09c John W. Linville       2010-07-29  3502   *
79b1c460a0 Bruno Randolf          2010-11-24  3503   * @set_antenna: Set antenna configuration (tx_ant, rx_ant) on the device.
79b1c460a0 Bruno Randolf          2010-11-24  3504   *	Parameters are bitmaps of allowed antennas to use for TX/RX. Drivers may
79b1c460a0 Bruno Randolf          2010-11-24  3505   *	reject TX/RX mask combinations they cannot support by returning -EINVAL
79b1c460a0 Bruno Randolf          2010-11-24  3506   *	(also see nl80211.h @NL80211_ATTR_WIPHY_ANTENNA_TX).
79b1c460a0 Bruno Randolf          2010-11-24  3507   *
79b1c460a0 Bruno Randolf          2010-11-24  3508   * @get_antenna: Get current antenna configuration from device (tx_ant, rx_ant).
4976b4eb9d Johannes Berg          2011-01-04  3509   *
4976b4eb9d Johannes Berg          2011-01-04  3510   * @remain_on_channel: Starts an off-channel period on the given channel, must
4976b4eb9d Johannes Berg          2011-01-04  3511   *	call back to ieee80211_ready_on_channel() when on that channel. Note
4976b4eb9d Johannes Berg          2011-01-04  3512   *	that normal channel traffic is not stopped as this is intended for hw
4976b4eb9d Johannes Berg          2011-01-04  3513   *	offload. Frames to transmit on the off-channel channel are transmitted
4976b4eb9d Johannes Berg          2011-01-04  3514   *	normally except for the %IEEE80211_TX_CTL_TX_OFFCHAN flag. When the
4976b4eb9d Johannes Berg          2011-01-04  3515   *	duration (which will always be non-zero) expires, the driver must call
196ac1c13d Johannes Berg          2012-06-05  3516   *	ieee80211_remain_on_channel_expired().
196ac1c13d Johannes Berg          2012-06-05  3517   *	Note that this callback may be called while the device is in IDLE and
196ac1c13d Johannes Berg          2012-06-05  3518   *	must be accepted in this case.
196ac1c13d Johannes Berg          2012-06-05  3519   *	This callback may sleep.
4976b4eb9d Johannes Berg          2011-01-04  3520   * @cancel_remain_on_channel: Requests that an ongoing off-channel period is
4976b4eb9d Johannes Berg          2011-01-04  3521   *	aborted before it expires. This callback may sleep.
38c091590f John W. Linville       2011-03-07  3522   *
38c091590f John W. Linville       2011-03-07  3523   * @set_ringparam: Set tx and rx ring sizes.
38c091590f John W. Linville       2011-03-07  3524   *
38c091590f John W. Linville       2011-03-07  3525   * @get_ringparam: Get tx and rx ring current and maximum sizes.
e8306f9894 Vivek Natarajan        2011-04-06  3526   *
e8306f9894 Vivek Natarajan        2011-04-06  3527   * @tx_frames_pending: Check if there is any pending frame in the hardware
e8306f9894 Vivek Natarajan        2011-04-06  3528   *	queues before entering power save.
bdbfd6b582 Sujith Manoharan       2011-04-27  3529   *
bdbfd6b582 Sujith Manoharan       2011-04-27  3530   * @set_bitrate_mask: Set a mask of rates to be used for rate control selection
bdbfd6b582 Sujith Manoharan       2011-04-27  3531   *	when transmitting a frame. Currently only legacy rates are handled.
bdbfd6b582 Sujith Manoharan       2011-04-27  3532   *	The callback can sleep.
a818292952 Emmanuel Grumbach      2015-03-16  3533   * @event_callback: Notify driver about any event in mac80211. See
a818292952 Emmanuel Grumbach      2015-03-16  3534   *	&enum ieee80211_event_type for the different types.
6382246e89 Emmanuel Grumbach      2015-04-20  3535   *	The callback must be atomic.
4049e09acd Johannes Berg          2011-09-29  3536   *
4049e09acd Johannes Berg          2011-09-29  3537   * @release_buffered_frames: Release buffered frames according to the given
4049e09acd Johannes Berg          2011-09-29  3538   *	parameters. In the case where the driver buffers some frames for
4049e09acd Johannes Berg          2011-09-29  3539   *	sleeping stations mac80211 will use this callback to tell the driver
4049e09acd Johannes Berg          2011-09-29  3540   *	to release some frames, either for PS-poll or uAPSD.
e227867f12 Masanari Iida          2014-02-18  3541   *	Note that if the @more_data parameter is %false the driver must check
4049e09acd Johannes Berg          2011-09-29  3542   *	if there are more frames on the given TIDs, and if there are more than
4049e09acd Johannes Berg          2011-09-29  3543   *	the frames being released then it must still set the more-data bit in
4049e09acd Johannes Berg          2011-09-29  3544   *	the frame. If the @more_data parameter is %true, then of course the
4049e09acd Johannes Berg          2011-09-29  3545   *	more-data bit must always be set.
4049e09acd Johannes Berg          2011-09-29  3546   *	The @tids parameter tells the driver which TIDs to release frames
4049e09acd Johannes Berg          2011-09-29  3547   *	from, for PS-poll it will always have only a single bit set.
deeaee197b Johannes Berg          2011-09-29  3548   *	In the case this is used for a PS-poll initiated release, the
deeaee197b Johannes Berg          2011-09-29  3549   *	@num_frames parameter will always be 1 so code can be shared. In
deeaee197b Johannes Berg          2011-09-29  3550   *	this case the driver must also set %IEEE80211_TX_STATUS_EOSP flag
deeaee197b Johannes Berg          2011-09-29  3551   *	on the TX status (and must report TX status) so that the PS-poll
deeaee197b Johannes Berg          2011-09-29  3552   *	period is properly ended. This is used to avoid sending multiple
deeaee197b Johannes Berg          2011-09-29  3553   *	responses for a retried PS-poll frame.
4049e09acd Johannes Berg          2011-09-29  3554   *	In the case this is used for uAPSD, the @num_frames parameter may be
4049e09acd Johannes Berg          2011-09-29  3555   *	bigger than one, but the driver may send fewer frames (it must send
4049e09acd Johannes Berg          2011-09-29  3556   *	at least one, however). In this case it is also responsible for
47086fc51a Johannes Berg          2011-09-29  3557   *	setting the EOSP flag in the QoS header of the frames. Also, when the
47086fc51a Johannes Berg          2011-09-29  3558   *	service period ends, the driver must set %IEEE80211_TX_STATUS_EOSP
37fbd90800 Johannes Berg          2011-09-29  3559   *	on the last frame in the SP. Alternatively, it may call the function
e943789edb Johannes Berg          2013-02-15  3560   *	ieee80211_sta_eosp() to inform mac80211 of the end of the SP.
4049e09acd Johannes Berg          2011-09-29  3561   *	This callback must be atomic.
40b9640883 Johannes Berg          2011-09-29  3562   * @allow_buffered_frames: Prepare device to allow the given number of frames
40b9640883 Johannes Berg          2011-09-29  3563   *	to go out to the given station. The frames will be sent by mac80211
40b9640883 Johannes Berg          2011-09-29  3564   *	via the usual TX path after this call. The TX information for frames
02f2f1a951 Johannes Berg          2012-02-27  3565   *	released will also have the %IEEE80211_TX_CTL_NO_PS_BUFFER flag set
40b9640883 Johannes Berg          2011-09-29  3566   *	and the last one will also have %IEEE80211_TX_STATUS_EOSP set. In case
40b9640883 Johannes Berg          2011-09-29  3567   *	frames from multiple TIDs are released and the driver might reorder
40b9640883 Johannes Berg          2011-09-29  3568   *	them between the TIDs, it must set the %IEEE80211_TX_STATUS_EOSP flag
40b9640883 Johannes Berg          2011-09-29  3569   *	on the last frame and clear it on all others and also handle the EOSP
37fbd90800 Johannes Berg          2011-09-29  3570   *	bit in the QoS header correctly. Alternatively, it can also call the
e943789edb Johannes Berg          2013-02-15  3571   *	ieee80211_sta_eosp() function.
40b9640883 Johannes Berg          2011-09-29  3572   *	The @tids parameter is a bitmap and tells the driver which TIDs the
40b9640883 Johannes Berg          2011-09-29  3573   *	frames will be on; it will at most have two bits set.
40b9640883 Johannes Berg          2011-09-29  3574   *	This callback must be atomic.
e352114fd6 Ben Greear             2012-04-23  3575   *
e352114fd6 Ben Greear             2012-04-23  3576   * @get_et_sset_count:  Ethtool API to get string-set count.
e352114fd6 Ben Greear             2012-04-23  3577   *
e352114fd6 Ben Greear             2012-04-23  3578   * @get_et_stats:  Ethtool API to get a set of u64 stats.
e352114fd6 Ben Greear             2012-04-23  3579   *
e352114fd6 Ben Greear             2012-04-23  3580   * @get_et_strings:  Ethtool API to get a set of strings to describe stats
e352114fd6 Ben Greear             2012-04-23  3581   *	and perhaps other supported types of ethtool data-sets.
e352114fd6 Ben Greear             2012-04-23  3582   *
a1845fc7c5 Johannes Berg          2012-06-27  3583   * @mgd_prepare_tx: Prepare for transmitting a management frame for association
a1845fc7c5 Johannes Berg          2012-06-27  3584   *	before associated. In multi-channel scenarios, a virtual interface is
a1845fc7c5 Johannes Berg          2012-06-27  3585   *	bound to a channel before it is associated, but as it isn't associated
a1845fc7c5 Johannes Berg          2012-06-27  3586   *	yet it need not necessarily be given airtime, in particular since any
a1845fc7c5 Johannes Berg          2012-06-27  3587   *	transmission to a P2P GO needs to be synchronized against the GO's
a1845fc7c5 Johannes Berg          2012-06-27  3588   *	powersave state. mac80211 will call this function before transmitting a
a1845fc7c5 Johannes Berg          2012-06-27  3589   *	management frame prior to having successfully associated to allow the
a1845fc7c5 Johannes Berg          2012-06-27  3590   *	driver to give it channel time for the transmission, to get a response
a1845fc7c5 Johannes Berg          2012-06-27  3591   *	and to be able to synchronize with the GO.
94ba92713f Ilan Peer              2018-02-19  3592   *	For drivers that set %IEEE80211_HW_DEAUTH_NEED_MGD_TX_PREP, mac80211
94ba92713f Ilan Peer              2018-02-19  3593   *	would also call this function before transmitting a deauthentication
94ba92713f Ilan Peer              2018-02-19  3594   *	frame in case that no beacon was heard from the AP/P2P GO.
a1845fc7c5 Johannes Berg          2012-06-27  3595   *	The callback will be called before each transmission and upon return
a1845fc7c5 Johannes Berg          2012-06-27  3596   *	mac80211 will transmit the frame right away.
d4e36e5554 Ilan Peer              2018-04-20  3597   *      If duration is greater than zero, mac80211 hints to the driver the
d4e36e5554 Ilan Peer              2018-04-20  3598   *      duration for which the operation is requested.
a1845fc7c5 Johannes Berg          2012-06-27  3599   *	The callback is optional and can (should!) sleep.
c3645eac47 Michal Kazior          2012-06-26  3600   *
ee10f2c779 Arik Nemtsov           2014-06-11  3601   * @mgd_protect_tdls_discover: Protect a TDLS discovery session. After sending
ee10f2c779 Arik Nemtsov           2014-06-11  3602   *	a TDLS discovery-request, we expect a reply to arrive on the AP's
ee10f2c779 Arik Nemtsov           2014-06-11  3603   *	channel. We must stay on the channel (no PSM, scan, etc.), since a TDLS
ee10f2c779 Arik Nemtsov           2014-06-11  3604   *	setup-response is a direct packet not buffered by the AP.
ee10f2c779 Arik Nemtsov           2014-06-11  3605   *	mac80211 will call this function just before the transmission of a TDLS
ee10f2c779 Arik Nemtsov           2014-06-11  3606   *	discovery-request. The recommended period of protection is at least
ee10f2c779 Arik Nemtsov           2014-06-11  3607   *	2 * (DTIM period).
ee10f2c779 Arik Nemtsov           2014-06-11  3608   *	The callback is optional and can sleep.
ee10f2c779 Arik Nemtsov           2014-06-11  3609   *
c3645eac47 Michal Kazior          2012-06-26  3610   * @add_chanctx: Notifies device driver about new channel context creation.
dcae9e0203 Chaitanya T K          2015-10-30  3611   *	This callback may sleep.
c3645eac47 Michal Kazior          2012-06-26  3612   * @remove_chanctx: Notifies device driver about channel context destruction.
dcae9e0203 Chaitanya T K          2015-10-30  3613   *	This callback may sleep.
c3645eac47 Michal Kazior          2012-06-26  3614   * @change_chanctx: Notifies device driver about channel context changes that
c3645eac47 Michal Kazior          2012-06-26  3615   *	may happen when combining different virtual interfaces on the same
c3645eac47 Michal Kazior          2012-06-26  3616   *	channel context with different settings
dcae9e0203 Chaitanya T K          2015-10-30  3617   *	This callback may sleep.
c3645eac47 Michal Kazior          2012-06-26  3618   * @assign_vif_chanctx: Notifies device driver about channel context being bound
c3645eac47 Michal Kazior          2012-06-26  3619   *	to vif. Possible use is for hw queue remapping.
dcae9e0203 Chaitanya T K          2015-10-30  3620   *	This callback may sleep.
c3645eac47 Michal Kazior          2012-06-26  3621   * @unassign_vif_chanctx: Notifies device driver about channel context being
c3645eac47 Michal Kazior          2012-06-26  3622   *	unbound from vif.
dcae9e0203 Chaitanya T K          2015-10-30  3623   *	This callback may sleep.
1a5f0c13d1 Luciano Coelho         2014-05-23  3624   * @switch_vif_chanctx: switch a number of vifs from one chanctx to
1a5f0c13d1 Luciano Coelho         2014-05-23  3625   *	another, as specified in the list of
1a5f0c13d1 Luciano Coelho         2014-05-23  3626   *	@ieee80211_vif_chanctx_switch passed to the driver, according
1a5f0c13d1 Luciano Coelho         2014-05-23  3627   *	to the mode defined in &ieee80211_chanctx_switch_mode.
dcae9e0203 Chaitanya T K          2015-10-30  3628   *	This callback may sleep.
1a5f0c13d1 Luciano Coelho         2014-05-23  3629   *
1041638f2b Johannes Berg          2012-10-19  3630   * @start_ap: Start operation on the AP interface, this is called after all the
1041638f2b Johannes Berg          2012-10-19  3631   *	information in bss_conf is set and beacon can be retrieved. A channel
1041638f2b Johannes Berg          2012-10-19  3632   *	context is bound before this is called. Note that if the driver uses
1041638f2b Johannes Berg          2012-10-19  3633   *	software scan or ROC, this (and @stop_ap) isn't called when the AP is
1041638f2b Johannes Berg          2012-10-19  3634   *	just "paused" for scanning/ROC, which is indicated by the beacon being
1041638f2b Johannes Berg          2012-10-19  3635   *	disabled/enabled via @bss_info_changed.
1041638f2b Johannes Berg          2012-10-19  3636   * @stop_ap: Stop operation on the AP interface.
9214ad7f9a Johannes Berg          2012-11-06  3637   *
cf2c92d840 Eliad Peller           2014-11-04  3638   * @reconfig_complete: Called after a call to ieee80211_restart_hw() and
cf2c92d840 Eliad Peller           2014-11-04  3639   *	during resume, when the reconfiguration has completed.
cf2c92d840 Eliad Peller           2014-11-04  3640   *	This can help the driver implement the reconfiguration step (and
cf2c92d840 Eliad Peller           2014-11-04  3641   *	indicate mac80211 is ready to receive frames).
cf2c92d840 Eliad Peller           2014-11-04  3642   *	This callback may sleep.
8f21b0adfe Johannes Berg          2013-01-11  3643   *
a65240c101 Johannes Berg          2013-01-14  3644   * @ipv6_addr_change: IPv6 address assignment on the given interface changed.
a65240c101 Johannes Berg          2013-01-14  3645   *	Currently, this is only called for managed or P2P client interfaces.
a65240c101 Johannes Berg          2013-01-14  3646   *	This callback is optional; it must not sleep.
73da7d5bab Simon Wunderlich       2013-07-11  3647   *
73da7d5bab Simon Wunderlich       2013-07-11  3648   * @channel_switch_beacon: Starts a channel switch to a new channel.
73da7d5bab Simon Wunderlich       2013-07-11  3649   *	Beacons are modified to include CSA or ECSA IEs before calling this
73da7d5bab Simon Wunderlich       2013-07-11  3650   *	function. The corresponding count fields in these IEs must be
66e01cf99e Luciano Coelho         2014-01-13  3651   *	decremented, and when they reach 1 the driver must call
73da7d5bab Simon Wunderlich       2013-07-11  3652   *	ieee80211_csa_finish(). Drivers which use ieee80211_beacon_get()
73da7d5bab Simon Wunderlich       2013-07-11  3653   *	get the csa counter decremented by mac80211, but must check if it is
66e01cf99e Luciano Coelho         2014-01-13  3654   *	1 using ieee80211_csa_is_complete() after the beacon has been
73da7d5bab Simon Wunderlich       2013-07-11  3655   *	transmitted and then call ieee80211_csa_finish().
66e01cf99e Luciano Coelho         2014-01-13  3656   *	If the CSA count starts as zero or 1, this function will not be called,
66e01cf99e Luciano Coelho         2014-01-13  3657   *	since there won't be any time to beacon before the switch anyway.
6d027bcc8a Luciano Coelho         2014-10-08  3658   * @pre_channel_switch: This is an optional callback that is called
6d027bcc8a Luciano Coelho         2014-10-08  3659   *	before a channel switch procedure is started (ie. when a STA
9332ef9dbd Masahiro Yamada        2017-02-27  3660   *	gets a CSA or a userspace initiated channel-switch), allowing
6d027bcc8a Luciano Coelho         2014-10-08  3661   *	the driver to prepare for the channel switch.
f1d65583bc Luciano Coelho         2014-10-08  3662   * @post_channel_switch: This is an optional callback that is called
f1d65583bc Luciano Coelho         2014-10-08  3663   *	after a channel switch procedure is completed, allowing the
f1d65583bc Luciano Coelho         2014-10-08  3664   *	driver to go back to a normal configuration.
b9cc81d827 Sara Sharon            2019-02-06  3665   * @abort_channel_switch: This is an optional callback that is called
b9cc81d827 Sara Sharon            2019-02-06  3666   *	when channel switch procedure was completed, allowing the
b9cc81d827 Sara Sharon            2019-02-06  3667   *	driver to go back to a normal configuration.
fafd2bce5a Sara Sharon            2019-02-06  3668   * @channel_switch_rx_beacon: This is an optional callback that is called
fafd2bce5a Sara Sharon            2019-02-06  3669   *	when channel switch procedure is in progress and additional beacon with
fafd2bce5a Sara Sharon            2019-02-06  3670   *	CSA IE was received, allowing driver to track changes in count.
55fff50113 Johannes Berg          2013-08-19  3671   * @join_ibss: Join an IBSS (on an IBSS interface); this is called after all
55fff50113 Johannes Berg          2013-08-19  3672   *	information in bss_conf is set up and the beacon can be retrieved. A
55fff50113 Johannes Berg          2013-08-19  3673   *	channel context is bound before this is called.
55fff50113 Johannes Berg          2013-08-19  3674   * @leave_ibss: Leave the IBSS again.
cca674d47e Antonio Quartulli      2014-05-19  3675   *
cca674d47e Antonio Quartulli      2014-05-19  3676   * @get_expected_throughput: extract the expected throughput towards the
cca674d47e Antonio Quartulli      2014-05-19  3677   *	specified station. The returned value is expressed in Kbps. It returns 0
cca674d47e Antonio Quartulli      2014-05-19  3678   *	if the RC algorithm does not have proper data to provide.
5b3dc42b1b Felix Fietkau          2014-10-26  3679   *
5b3dc42b1b Felix Fietkau          2014-10-26  3680   * @get_txpower: get current maximum tx power (in dBm) based on configuration
5b3dc42b1b Felix Fietkau          2014-10-26  3681   *	and hardware limits.
a7a6bdd067 Arik Nemtsov           2014-11-09  3682   *
a7a6bdd067 Arik Nemtsov           2014-11-09  3683   * @tdls_channel_switch: Start channel-switching with a TDLS peer. The driver
a7a6bdd067 Arik Nemtsov           2014-11-09  3684   *	is responsible for continually initiating channel-switching operations
a7a6bdd067 Arik Nemtsov           2014-11-09  3685   *	and returning to the base channel for communication with the AP. The
a7a6bdd067 Arik Nemtsov           2014-11-09  3686   *	driver receives a channel-switch request template and the location of
a7a6bdd067 Arik Nemtsov           2014-11-09  3687   *	the switch-timing IE within the template as part of the invocation.
a7a6bdd067 Arik Nemtsov           2014-11-09  3688   *	The template is valid only within the call, and the driver can
a7a6bdd067 Arik Nemtsov           2014-11-09  3689   *	optionally copy the skb for further re-use.
a7a6bdd067 Arik Nemtsov           2014-11-09  3690   * @tdls_cancel_channel_switch: Stop channel-switching with a TDLS peer. Both
a7a6bdd067 Arik Nemtsov           2014-11-09  3691   *	peers must be on the base channel when the call completes.
8a4d32f30d Arik Nemtsov           2014-11-09  3692   * @tdls_recv_channel_switch: a TDLS channel-switch related frame (request or
8a4d32f30d Arik Nemtsov           2014-11-09  3693   *	response) has been received from a remote peer. The driver gets
8a4d32f30d Arik Nemtsov           2014-11-09  3694   *	parameters parsed from the incoming frame and may use them to continue
8a4d32f30d Arik Nemtsov           2014-11-09  3695   *	an ongoing channel-switch operation. In addition, a channel-switch
8a4d32f30d Arik Nemtsov           2014-11-09  3696   *	response template is provided, together with the location of the
8a4d32f30d Arik Nemtsov           2014-11-09  3697   *	switch-timing IE within the template. The skb can only be used within
8a4d32f30d Arik Nemtsov           2014-11-09  3698   *	the function call.
ba8c3d6f16 Felix Fietkau          2015-03-27  3699   *
ba8c3d6f16 Felix Fietkau          2015-03-27  3700   * @wake_tx_queue: Called when new packets have been added to the queue.
f59374eb42 Sara Sharon            2016-03-02  3701   * @sync_rx_queues: Process all pending frames in RSS queues. This is a
f59374eb42 Sara Sharon            2016-03-02  3702   *	synchronization which is needed in case driver has in its RSS queues
f59374eb42 Sara Sharon            2016-03-02  3703   *	pending frames that were received prior to the control path action
f59374eb42 Sara Sharon            2016-03-02  3704   *	currently taken (e.g. disassociation) but are not processed yet.
708d50edb1 Ayala Beker            2016-09-20  3705   *
708d50edb1 Ayala Beker            2016-09-20  3706   * @start_nan: join an existing NAN cluster, or create a new one.
708d50edb1 Ayala Beker            2016-09-20  3707   * @stop_nan: leave the NAN cluster.
5953ff6d6a Ayala Beker            2016-09-20  3708   * @nan_change_conf: change NAN configuration. The data in cfg80211_nan_conf
5953ff6d6a Ayala Beker            2016-09-20  3709   *	contains full new configuration and changes specify which parameters
5953ff6d6a Ayala Beker            2016-09-20  3710   *	are changed with respect to the last NAN config.
5953ff6d6a Ayala Beker            2016-09-20  3711   *	The driver gets both full configuration and the changed parameters since
5953ff6d6a Ayala Beker            2016-09-20  3712   *	some devices may need the full configuration while others need only the
5953ff6d6a Ayala Beker            2016-09-20  3713   *	changed parameters.
167e33f4f6 Ayala Beker            2016-09-20  3714   * @add_nan_func: Add a NAN function. Returns 0 on success. The data in
167e33f4f6 Ayala Beker            2016-09-20  3715   *	cfg80211_nan_func must not be referenced outside the scope of
167e33f4f6 Ayala Beker            2016-09-20  3716   *	this call.
167e33f4f6 Ayala Beker            2016-09-20  3717   * @del_nan_func: Remove a NAN function. The driver must call
167e33f4f6 Ayala Beker            2016-09-20  3718   *	ieee80211_nan_func_terminated() with
167e33f4f6 Ayala Beker            2016-09-20  3719   *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
9739fe29a2 Sara Sharon            2018-09-05  3720   * @can_aggregate_in_amsdu: Called in order to determine if HW supports
9739fe29a2 Sara Sharon            2018-09-05  3721   *	aggregating two specific frames in the same A-MSDU. The relation
9739fe29a2 Sara Sharon            2018-09-05  3722   *	between the skbs should be symmetric and transitive. Note that while
9739fe29a2 Sara Sharon            2018-09-05  3723   *	skb is always a real frame, head may or may not be an A-MSDU.
bc847970f4 Pradeep Kumar Chitrapu 2018-10-03  3724   * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
bc847970f4 Pradeep Kumar Chitrapu 2018-10-03  3725   *	Statistics should be cumulative, currently no way to reset is provided.
cee7013be9 Johannes Berg          2018-10-16  3726   *
cee7013be9 Johannes Berg          2018-10-16  3727   * @start_pmsr: start peer measurement (e.g. FTM) (this call can sleep)
cee7013be9 Johannes Berg          2018-10-16  3728   * @abort_pmsr: abort peer measurement (this call can sleep)
8f20fc2498 Johannes Berg          2007-08-28  3729   */
75a5f0ccfd Johannes Berg          2007-09-18  3730  struct ieee80211_ops {
36323f817a Thomas Huehn           2012-07-23  3731  	void (*tx)(struct ieee80211_hw *hw,
36323f817a Thomas Huehn           2012-07-23  3732  		   struct ieee80211_tx_control *control,
36323f817a Thomas Huehn           2012-07-23  3733  		   struct sk_buff *skb);
75a5f0ccfd Johannes Berg          2007-09-18  3734  	int (*start)(struct ieee80211_hw *hw);
75a5f0ccfd Johannes Berg          2007-09-18  3735  	void (*stop)(struct ieee80211_hw *hw);
eecc48000a Johannes Berg          2011-05-04  3736  #ifdef CONFIG_PM
eecc48000a Johannes Berg          2011-05-04  3737  	int (*suspend)(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan);
eecc48000a Johannes Berg          2011-05-04  3738  	int (*resume)(struct ieee80211_hw *hw);
6d52563f2b Johannes Berg          2012-04-04  3739  	void (*set_wakeup)(struct ieee80211_hw *hw, bool enabled);
eecc48000a Johannes Berg          2011-05-04  3740  #endif
75a5f0ccfd Johannes Berg          2007-09-18  3741  	int (*add_interface)(struct ieee80211_hw *hw,
1ed32e4fc8 Johannes Berg          2009-12-23  3742  			     struct ieee80211_vif *vif);
34d4bc4d41 Johannes Berg          2010-08-27  3743  	int (*change_interface)(struct ieee80211_hw *hw,
34d4bc4d41 Johannes Berg          2010-08-27  3744  				struct ieee80211_vif *vif,
2ca27bcff7 Johannes Berg          2010-09-16  3745  				enum nl80211_iftype new_type, bool p2p);
75a5f0ccfd Johannes Berg          2007-09-18  3746  	void (*remove_interface)(struct ieee80211_hw *hw,
1ed32e4fc8 Johannes Berg          2009-12-23  3747  				 struct ieee80211_vif *vif);
e8975581f6 Johannes Berg          2008-10-09  3748  	int (*config)(struct ieee80211_hw *hw, u32 changed);
471b3efdfc Johannes Berg          2007-12-28  3749  	void (*bss_info_changed)(struct ieee80211_hw *hw,
471b3efdfc Johannes Berg          2007-12-28  3750  				 struct ieee80211_vif *vif,
471b3efdfc Johannes Berg          2007-12-28  3751  				 struct ieee80211_bss_conf *info,
471b3efdfc Johannes Berg          2007-12-28  3752  				 u32 changed);
b2abb6e2bc Johannes Berg          2011-07-19  3753  
1041638f2b Johannes Berg          2012-10-19  3754  	int (*start_ap)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
1041638f2b Johannes Berg          2012-10-19  3755  	void (*stop_ap)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
1041638f2b Johannes Berg          2012-10-19  3756  
3ac64beecd Johannes Berg          2009-08-17  3757  	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
22bedad3ce Jiri Pirko             2010-04-01  3758  				 struct netdev_hw_addr_list *mc_list);
75a5f0ccfd Johannes Berg          2007-09-18  3759  	void (*configure_filter)(struct ieee80211_hw *hw,
75a5f0ccfd Johannes Berg          2007-09-18  3760  				 unsigned int changed_flags,
75a5f0ccfd Johannes Berg          2007-09-18  3761  				 unsigned int *total_flags,
3ac64beecd Johannes Berg          2009-08-17  3762  				 u64 multicast);
1b09b5568e Andrei Otcheretianski  2015-08-15  3763  	void (*config_iface_filter)(struct ieee80211_hw *hw,
1b09b5568e Andrei Otcheretianski  2015-08-15  3764  				    struct ieee80211_vif *vif,
1b09b5568e Andrei Otcheretianski  2015-08-15  3765  				    unsigned int filter_flags,
1b09b5568e Andrei Otcheretianski  2015-08-15  3766  				    unsigned int changed_flags);
17741cdc26 Johannes Berg          2008-09-11  3767  	int (*set_tim)(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
17741cdc26 Johannes Berg          2008-09-11  3768  		       bool set);
ea49c359f3 Johannes Berg          2007-09-18  3769  	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
dc822b5db4 Johannes Berg          2008-12-29  3770  		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
11a843b7e1 Johannes Berg          2007-08-28  3771  		       struct ieee80211_key_conf *key);
9ae4fda332 Emmanuel Grumbach      2008-03-20  3772  	void (*update_tkip_key)(struct ieee80211_hw *hw,
b3fbdcf49f Johannes Berg          2010-01-21  3773  				struct ieee80211_vif *vif,
b3fbdcf49f Johannes Berg          2010-01-21  3774  				struct ieee80211_key_conf *conf,
b3fbdcf49f Johannes Berg          2010-01-21  3775  				struct ieee80211_sta *sta,
9ae4fda332 Emmanuel Grumbach      2008-03-20  3776  				u32 iv32, u16 *phase1key);
c68f4b892c Johannes Berg          2011-07-05  3777  	void (*set_rekey_data)(struct ieee80211_hw *hw,
c68f4b892c Johannes Berg          2011-07-05  3778  			       struct ieee80211_vif *vif,
c68f4b892c Johannes Berg          2011-07-05  3779  			       struct cfg80211_gtk_rekey_data *data);
de5fad8157 Yoni Divinsky          2012-05-30  3780  	void (*set_default_unicast_key)(struct ieee80211_hw *hw,
de5fad8157 Yoni Divinsky          2012-05-30  3781  					struct ieee80211_vif *vif, int idx);
a060bbfe4e Johannes Berg          2010-04-27  3782  	int (*hw_scan)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
c56ef67250 David Spinadel         2014-02-05  3783  		       struct ieee80211_scan_request *req);
b856439b1b Eliad Peller           2011-06-13  3784  	void (*cancel_hw_scan)(struct ieee80211_hw *hw,
b856439b1b Eliad Peller           2011-06-13  3785  			       struct ieee80211_vif *vif);
79f460ca49 Luciano Coelho         2011-05-11  3786  	int (*sched_scan_start)(struct ieee80211_hw *hw,
79f460ca49 Luciano Coelho         2011-05-11  3787  				struct ieee80211_vif *vif,
79f460ca49 Luciano Coelho         2011-05-11  3788  				struct cfg80211_sched_scan_request *req,
633e271326 David Spinadel         2014-02-06  3789  				struct ieee80211_scan_ies *ies);
37e3308cb2 Johannes Berg          2014-02-17  3790  	int (*sched_scan_stop)(struct ieee80211_hw *hw,
79f460ca49 Luciano Coelho         2011-05-11  3791  			       struct ieee80211_vif *vif);
a344d6778a Johannes Berg          2014-06-12  3792  	void (*sw_scan_start)(struct ieee80211_hw *hw,
a344d6778a Johannes Berg          2014-06-12  3793  			      struct ieee80211_vif *vif,
a344d6778a Johannes Berg          2014-06-12  3794  			      const u8 *mac_addr);
a344d6778a Johannes Berg          2014-06-12  3795  	void (*sw_scan_complete)(struct ieee80211_hw *hw,
a344d6778a Johannes Berg          2014-06-12  3796  				 struct ieee80211_vif *vif);
f0706e828e Jiri Benc              2007-05-05  3797  	int (*get_stats)(struct ieee80211_hw *hw,
f0706e828e Jiri Benc              2007-05-05  3798  			 struct ieee80211_low_level_stats *stats);
9352c19f63 Johannes Berg          2015-04-20  3799  	void (*get_key_seq)(struct ieee80211_hw *hw,
9352c19f63 Johannes Berg          2015-04-20  3800  			    struct ieee80211_key_conf *key,
9352c19f63 Johannes Berg          2015-04-20  3801  			    struct ieee80211_key_seq *seq);
f23a478075 Arik Nemtsov           2010-11-08  3802  	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
f0706e828e Jiri Benc              2007-05-05  3803  	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
34e895075e Johannes Berg          2010-02-03  3804  	int (*sta_add)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
34e895075e Johannes Berg          2010-02-03  3805  		       struct ieee80211_sta *sta);
34e895075e Johannes Berg          2010-02-03  3806  	int (*sta_remove)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
34e895075e Johannes Berg          2010-02-03  3807  			  struct ieee80211_sta *sta);
77d2ece6fd Sujith Manoharan       2012-11-20  3808  #ifdef CONFIG_MAC80211_DEBUGFS
77d2ece6fd Sujith Manoharan       2012-11-20  3809  	void (*sta_add_debugfs)(struct ieee80211_hw *hw,
77d2ece6fd Sujith Manoharan       2012-11-20  3810  				struct ieee80211_vif *vif,
77d2ece6fd Sujith Manoharan       2012-11-20  3811  				struct ieee80211_sta *sta,
77d2ece6fd Sujith Manoharan       2012-11-20  3812  				struct dentry *dir);
77d2ece6fd Sujith Manoharan       2012-11-20  3813  #endif
32bfd35d4b Johannes Berg          2007-12-19  3814  	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
17741cdc26 Johannes Berg          2008-09-11  3815  			enum sta_notify_cmd, struct ieee80211_sta *sta);
f6a144eae3 Ashok Raj Nagarajan    2019-03-29  3816  	int (*sta_set_txpwr)(struct ieee80211_hw *hw,
f6a144eae3 Ashok Raj Nagarajan    2019-03-29  3817  			     struct ieee80211_vif *vif,
f6a144eae3 Ashok Raj Nagarajan    2019-03-29  3818  			     struct ieee80211_sta *sta);
f09603a259 Johannes Berg          2012-01-20  3819  	int (*sta_state)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
f09603a259 Johannes Berg          2012-01-20  3820  			 struct ieee80211_sta *sta,
f09603a259 Johannes Berg          2012-01-20  3821  			 enum ieee80211_sta_state old_state,
f09603a259 Johannes Berg          2012-01-20  3822  			 enum ieee80211_sta_state new_state);
6a9d1b91f3 Johannes Berg          2013-12-04  3823  	void (*sta_pre_rcu_remove)(struct ieee80211_hw *hw,
6a9d1b91f3 Johannes Berg          2013-12-04  3824  				   struct ieee80211_vif *vif,
6a9d1b91f3 Johannes Berg          2013-12-04  3825  				   struct ieee80211_sta *sta);
8f727ef3c4 Johannes Berg          2012-03-30  3826  	void (*sta_rc_update)(struct ieee80211_hw *hw,
8f727ef3c4 Johannes Berg          2012-03-30  3827  			      struct ieee80211_vif *vif,
8f727ef3c4 Johannes Berg          2012-03-30  3828  			      struct ieee80211_sta *sta,
8f727ef3c4 Johannes Berg          2012-03-30  3829  			      u32 changed);
f815e2b3c0 Johannes Berg          2014-11-19  3830  	void (*sta_rate_tbl_update)(struct ieee80211_hw *hw,
f815e2b3c0 Johannes Berg          2014-11-19  3831  				    struct ieee80211_vif *vif,
f815e2b3c0 Johannes Berg          2014-11-19  3832  				    struct ieee80211_sta *sta);
2b9a7e1bac Johannes Berg          2014-11-17  3833  	void (*sta_statistics)(struct ieee80211_hw *hw,
2b9a7e1bac Johannes Berg          2014-11-17  3834  			       struct ieee80211_vif *vif,
2b9a7e1bac Johannes Berg          2014-11-17  3835  			       struct ieee80211_sta *sta,
2b9a7e1bac Johannes Berg          2014-11-17  3836  			       struct station_info *sinfo);
8a3a3c85e4 Eliad Peller           2011-10-02  3837  	int (*conf_tx)(struct ieee80211_hw *hw,
a3304b0a17 Johannes Berg          2012-03-28  3838  		       struct ieee80211_vif *vif, u16 ac,
f0706e828e Jiri Benc              2007-05-05  3839  		       const struct ieee80211_tx_queue_params *params);
37a41b4aff Eliad Peller           2011-09-21  3840  	u64 (*get_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
37a41b4aff Eliad Peller           2011-09-21  3841  	void (*set_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
37a41b4aff Eliad Peller           2011-09-21  3842  			u64 tsf);
354d381baf Pedersen, Thomas       2016-09-28  3843  	void (*offset_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
354d381baf Pedersen, Thomas       2016-09-28  3844  			   s64 offset);
37a41b4aff Eliad Peller           2011-09-21  3845  	void (*reset_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
f0706e828e Jiri Benc              2007-05-05  3846  	int (*tx_last_beacon)(struct ieee80211_hw *hw);
57eeb2086d Johannes Berg          2017-01-13  3847  
57eeb2086d Johannes Berg          2017-01-13  3848  	/**
57eeb2086d Johannes Berg          2017-01-13  3849  	 * @ampdu_action:
57eeb2086d Johannes Berg          2017-01-13  3850  	 * Perform a certain A-MPDU action.
57eeb2086d Johannes Berg          2017-01-13  3851  	 * The RA/TID combination determines the destination and TID we want
57eeb2086d Johannes Berg          2017-01-13  3852  	 * the ampdu action to be performed for. The action is defined through
57eeb2086d Johannes Berg          2017-01-13  3853  	 * ieee80211_ampdu_mlme_action.
57eeb2086d Johannes Berg          2017-01-13  3854  	 * When the action is set to %IEEE80211_AMPDU_TX_OPERATIONAL the driver
57eeb2086d Johannes Berg          2017-01-13  3855  	 * may neither send aggregates containing more subframes than @buf_size
57eeb2086d Johannes Berg          2017-01-13  3856  	 * nor send aggregates in a way that lost frames would exceed the
57eeb2086d Johannes Berg          2017-01-13  3857  	 * buffer size. If just limiting the aggregate size, this would be
57eeb2086d Johannes Berg          2017-01-13  3858  	 * possible with a buf_size of 8:
57eeb2086d Johannes Berg          2017-01-13  3859  	 *
57eeb2086d Johannes Berg          2017-01-13  3860  	 * - ``TX: 1.....7``
57eeb2086d Johannes Berg          2017-01-13  3861  	 * - ``RX:  2....7`` (lost frame #1)
57eeb2086d Johannes Berg          2017-01-13  3862  	 * - ``TX:        8..1...``
57eeb2086d Johannes Berg          2017-01-13  3863  	 *
57eeb2086d Johannes Berg          2017-01-13  3864  	 * which is invalid since #1 was now re-transmitted well past the
57eeb2086d Johannes Berg          2017-01-13  3865  	 * buffer size of 8. Correct ways to retransmit #1 would be:
57eeb2086d Johannes Berg          2017-01-13  3866  	 *
57eeb2086d Johannes Berg          2017-01-13  3867  	 * - ``TX:        1   or``
57eeb2086d Johannes Berg          2017-01-13  3868  	 * - ``TX:        18  or``
57eeb2086d Johannes Berg          2017-01-13  3869  	 * - ``TX:        81``
57eeb2086d Johannes Berg          2017-01-13  3870  	 *
57eeb2086d Johannes Berg          2017-01-13  3871  	 * Even ``189`` would be wrong since 1 could be lost again.
57eeb2086d Johannes Berg          2017-01-13  3872  	 *
57eeb2086d Johannes Berg          2017-01-13  3873  	 * Returns a negative error code on failure.
57eeb2086d Johannes Berg          2017-01-13  3874  	 * The callback can sleep.
57eeb2086d Johannes Berg          2017-01-13  3875  	 */
1b7d03acbf Ron Rindjunsky         2007-12-25  3876  	int (*ampdu_action)(struct ieee80211_hw *hw,
c951ad3550 Johannes Berg          2009-11-16  3877  			    struct ieee80211_vif *vif,
50ea05efaf Sara Sharon            2015-12-30  3878  			    struct ieee80211_ampdu_params *params);
1289723ef2 Holger Schurig         2010-04-19  3879  	int (*get_survey)(struct ieee80211_hw *hw, int idx,
1289723ef2 Holger Schurig         2010-04-19  3880  		struct survey_info *survey);
1f87f7d3a3 Johannes Berg          2009-06-02  3881  	void (*rfkill_poll)(struct ieee80211_hw *hw);
a4bcaf5556 Lorenzo Bianconi       2014-09-04  3882  	void (*set_coverage_class)(struct ieee80211_hw *hw, s16 coverage_class);
aff89a9b90 Johannes Berg          2009-07-01  3883  #ifdef CONFIG_NL80211_TESTMODE
52981cd794 David Spinadel         2013-07-31  3884  	int (*testmode_cmd)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
52981cd794 David Spinadel         2013-07-31  3885  			    void *data, int len);
71063f0e89 Wey-Yi Guy             2011-05-20  3886  	int (*testmode_dump)(struct ieee80211_hw *hw, struct sk_buff *skb,
71063f0e89 Wey-Yi Guy             2011-05-20  3887  			     struct netlink_callback *cb,
71063f0e89 Wey-Yi Guy             2011-05-20  3888  			     void *data, int len);
aff89a9b90 Johannes Berg          2009-07-01  3889  #endif
77be2c54c5 Emmanuel Grumbach      2014-03-27  3890  	void (*flush)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
77be2c54c5 Emmanuel Grumbach      2014-03-27  3891  		      u32 queues, bool drop);
5ce6e438d5 Johannes Berg          2010-05-11  3892  	void (*channel_switch)(struct ieee80211_hw *hw,
0f791eb47f Luciano Coelho         2014-10-08  3893  			       struct ieee80211_vif *vif,
5ce6e438d5 Johannes Berg          2010-05-11  3894  			       struct ieee80211_channel_switch *ch_switch);
15d9675321 Bruno Randolf          2010-11-10  3895  	int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
15d9675321 Bruno Randolf          2010-11-10  3896  	int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
21f8358964 Johannes Berg          2010-12-18  3897  
21f8358964 Johannes Berg          2010-12-18  3898  	int (*remain_on_channel)(struct ieee80211_hw *hw,
4988456862 Eliad Peller           2012-11-19  3899  				 struct ieee80211_vif *vif,
21f8358964 Johannes Berg          2010-12-18  3900  				 struct ieee80211_channel *chan,
d339d5ca8e Ilan Peer              2013-02-12  3901  				 int duration,
d339d5ca8e Ilan Peer              2013-02-12  3902  				 enum ieee80211_roc_type type);
21f8358964 Johannes Berg          2010-12-18  3903  	int (*cancel_remain_on_channel)(struct ieee80211_hw *hw);
38c091590f John W. Linville       2011-03-07  3904  	int (*set_ringparam)(struct ieee80211_hw *hw, u32 tx, u32 rx);
38c091590f John W. Linville       2011-03-07  3905  	void (*get_ringparam)(struct ieee80211_hw *hw,
38c091590f John W. Linville       2011-03-07  3906  			      u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
e8306f9894 Vivek Natarajan        2011-04-06  3907  	bool (*tx_frames_pending)(struct ieee80211_hw *hw);
bdbfd6b582 Sujith Manoharan       2011-04-27  3908  	int (*set_bitrate_mask)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
bdbfd6b582 Sujith Manoharan       2011-04-27  3909  				const struct cfg80211_bitrate_mask *mask);
a818292952 Emmanuel Grumbach      2015-03-16  3910  	void (*event_callback)(struct ieee80211_hw *hw,
887da9176e Emmanuel Grumbach      2013-01-20  3911  			       struct ieee80211_vif *vif,
a818292952 Emmanuel Grumbach      2015-03-16  3912  			       const struct ieee80211_event *event);
4049e09acd Johannes Berg          2011-09-29  3913  
40b9640883 Johannes Berg          2011-09-29  3914  	void (*allow_buffered_frames)(struct ieee80211_hw *hw,
40b9640883 Johannes Berg          2011-09-29  3915  				      struct ieee80211_sta *sta,
40b9640883 Johannes Berg          2011-09-29  3916  				      u16 tids, int num_frames,
40b9640883 Johannes Berg          2011-09-29  3917  				      enum ieee80211_frame_release_type reason,
40b9640883 Johannes Berg          2011-09-29  3918  				      bool more_data);
4049e09acd Johannes Berg          2011-09-29  3919  	void (*release_buffered_frames)(struct ieee80211_hw *hw,
4049e09acd Johannes Berg          2011-09-29  3920  					struct ieee80211_sta *sta,
4049e09acd Johannes Berg          2011-09-29  3921  					u16 tids, int num_frames,
4049e09acd Johannes Berg          2011-09-29  3922  					enum ieee80211_frame_release_type reason,
4049e09acd Johannes Berg          2011-09-29  3923  					bool more_data);
e352114fd6 Ben Greear             2012-04-23  3924  
e352114fd6 Ben Greear             2012-04-23  3925  	int	(*get_et_sset_count)(struct ieee80211_hw *hw,
e352114fd6 Ben Greear             2012-04-23  3926  				     struct ieee80211_vif *vif, int sset);
e352114fd6 Ben Greear             2012-04-23  3927  	void	(*get_et_stats)(struct ieee80211_hw *hw,
e352114fd6 Ben Greear             2012-04-23  3928  				struct ieee80211_vif *vif,
e352114fd6 Ben Greear             2012-04-23  3929  				struct ethtool_stats *stats, u64 *data);
e352114fd6 Ben Greear             2012-04-23  3930  	void	(*get_et_strings)(struct ieee80211_hw *hw,
e352114fd6 Ben Greear             2012-04-23  3931  				  struct ieee80211_vif *vif,
e352114fd6 Ben Greear             2012-04-23  3932  				  u32 sset, u8 *data);
a1845fc7c5 Johannes Berg          2012-06-27  3933  
a1845fc7c5 Johannes Berg          2012-06-27  3934  	void	(*mgd_prepare_tx)(struct ieee80211_hw *hw,
d4e36e5554 Ilan Peer              2018-04-20  3935  				  struct ieee80211_vif *vif,
d4e36e5554 Ilan Peer              2018-04-20  3936  				  u16 duration);
c3645eac47 Michal Kazior          2012-06-26  3937  
ee10f2c779 Arik Nemtsov           2014-06-11  3938  	void	(*mgd_protect_tdls_discover)(struct ieee80211_hw *hw,
ee10f2c779 Arik Nemtsov           2014-06-11  3939  					     struct ieee80211_vif *vif);
ee10f2c779 Arik Nemtsov           2014-06-11  3940  
c3645eac47 Michal Kazior          2012-06-26  3941  	int (*add_chanctx)(struct ieee80211_hw *hw,
c3645eac47 Michal Kazior          2012-06-26  3942  			   struct ieee80211_chanctx_conf *ctx);
c3645eac47 Michal Kazior          2012-06-26  3943  	void (*remove_chanctx)(struct ieee80211_hw *hw,
c3645eac47 Michal Kazior          2012-06-26  3944  			       struct ieee80211_chanctx_conf *ctx);
c3645eac47 Michal Kazior          2012-06-26  3945  	void (*change_chanctx)(struct ieee80211_hw *hw,
c3645eac47 Michal Kazior          2012-06-26  3946  			       struct ieee80211_chanctx_conf *ctx,
c3645eac47 Michal Kazior          2012-06-26  3947  			       u32 changed);
c3645eac47 Michal Kazior          2012-06-26  3948  	int (*assign_vif_chanctx)(struct ieee80211_hw *hw,
c3645eac47 Michal Kazior          2012-06-26  3949  				  struct ieee80211_vif *vif,
c3645eac47 Michal Kazior          2012-06-26  3950  				  struct ieee80211_chanctx_conf *ctx);
c3645eac47 Michal Kazior          2012-06-26  3951  	void (*unassign_vif_chanctx)(struct ieee80211_hw *hw,
c3645eac47 Michal Kazior          2012-06-26  3952  				     struct ieee80211_vif *vif,
c3645eac47 Michal Kazior          2012-06-26  3953  				     struct ieee80211_chanctx_conf *ctx);
1a5f0c13d1 Luciano Coelho         2014-05-23  3954  	int (*switch_vif_chanctx)(struct ieee80211_hw *hw,
1a5f0c13d1 Luciano Coelho         2014-05-23  3955  				  struct ieee80211_vif_chanctx_switch *vifs,
1a5f0c13d1 Luciano Coelho         2014-05-23  3956  				  int n_vifs,
1a5f0c13d1 Luciano Coelho         2014-05-23  3957  				  enum ieee80211_chanctx_switch_mode mode);
9214ad7f9a Johannes Berg          2012-11-06  3958  
cf2c92d840 Eliad Peller           2014-11-04  3959  	void (*reconfig_complete)(struct ieee80211_hw *hw,
cf2c92d840 Eliad Peller           2014-11-04  3960  				  enum ieee80211_reconfig_type reconfig_type);
a65240c101 Johannes Berg          2013-01-14  3961  
a65240c101 Johannes Berg          2013-01-14  3962  #if IS_ENABLED(CONFIG_IPV6)
a65240c101 Johannes Berg          2013-01-14  3963  	void (*ipv6_addr_change)(struct ieee80211_hw *hw,
a65240c101 Johannes Berg          2013-01-14  3964  				 struct ieee80211_vif *vif,
a65240c101 Johannes Berg          2013-01-14  3965  				 struct inet6_dev *idev);
a65240c101 Johannes Berg          2013-01-14  3966  #endif
73da7d5bab Simon Wunderlich       2013-07-11  3967  	void (*channel_switch_beacon)(struct ieee80211_hw *hw,
73da7d5bab Simon Wunderlich       2013-07-11  3968  				      struct ieee80211_vif *vif,
73da7d5bab Simon Wunderlich       2013-07-11  3969  				      struct cfg80211_chan_def *chandef);
6d027bcc8a Luciano Coelho         2014-10-08  3970  	int (*pre_channel_switch)(struct ieee80211_hw *hw,
6d027bcc8a Luciano Coelho         2014-10-08  3971  				  struct ieee80211_vif *vif,
6d027bcc8a Luciano Coelho         2014-10-08  3972  				  struct ieee80211_channel_switch *ch_switch);
55fff50113 Johannes Berg          2013-08-19  3973  
f1d65583bc Luciano Coelho         2014-10-08  3974  	int (*post_channel_switch)(struct ieee80211_hw *hw,
f1d65583bc Luciano Coelho         2014-10-08  3975  				   struct ieee80211_vif *vif);
b9cc81d827 Sara Sharon            2019-02-06  3976  	void (*abort_channel_switch)(struct ieee80211_hw *hw,
b9cc81d827 Sara Sharon            2019-02-06  3977  				     struct ieee80211_vif *vif);
fafd2bce5a Sara Sharon            2019-02-06  3978  	void (*channel_switch_rx_beacon)(struct ieee80211_hw *hw,
fafd2bce5a Sara Sharon            2019-02-06  3979  					 struct ieee80211_vif *vif,
fafd2bce5a Sara Sharon            2019-02-06  3980  					 struct ieee80211_channel_switch *ch_switch);
f1d65583bc Luciano Coelho         2014-10-08  3981  
55fff50113 Johannes Berg          2013-08-19  3982  	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
55fff50113 Johannes Berg          2013-08-19  3983  	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
2439ca0402 Maxim Altshul          2016-08-04  3984  	u32 (*get_expected_throughput)(struct ieee80211_hw *hw,
2439ca0402 Maxim Altshul          2016-08-04  3985  				       struct ieee80211_sta *sta);
5b3dc42b1b Felix Fietkau          2014-10-26  3986  	int (*get_txpower)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
5b3dc42b1b Felix Fietkau          2014-10-26  3987  			   int *dbm);
a7a6bdd067 Arik Nemtsov           2014-11-09  3988  
a7a6bdd067 Arik Nemtsov           2014-11-09  3989  	int (*tdls_channel_switch)(struct ieee80211_hw *hw,
a7a6bdd067 Arik Nemtsov           2014-11-09  3990  				   struct ieee80211_vif *vif,
a7a6bdd067 Arik Nemtsov           2014-11-09  3991  				   struct ieee80211_sta *sta, u8 oper_class,
a7a6bdd067 Arik Nemtsov           2014-11-09  3992  				   struct cfg80211_chan_def *chandef,
8a4d32f30d Arik Nemtsov           2014-11-09  3993  				   struct sk_buff *tmpl_skb, u32 ch_sw_tm_ie);
a7a6bdd067 Arik Nemtsov           2014-11-09  3994  	void (*tdls_cancel_channel_switch)(struct ieee80211_hw *hw,
a7a6bdd067 Arik Nemtsov           2014-11-09  3995  					   struct ieee80211_vif *vif,
a7a6bdd067 Arik Nemtsov           2014-11-09  3996  					   struct ieee80211_sta *sta);
8a4d32f30d Arik Nemtsov           2014-11-09  3997  	void (*tdls_recv_channel_switch)(struct ieee80211_hw *hw,
8a4d32f30d Arik Nemtsov           2014-11-09  3998  					 struct ieee80211_vif *vif,
8a4d32f30d Arik Nemtsov           2014-11-09  3999  					 struct ieee80211_tdls_ch_sw_params *params);
ba8c3d6f16 Felix Fietkau          2015-03-27  4000  
e7881bd594 Johannes Berg          2017-12-19  4001  	void (*wake_tx_queue)(struct ieee80211_hw *hw,
e7881bd594 Johannes Berg          2017-12-19  4002  			      struct ieee80211_txq *txq);
f59374eb42 Sara Sharon            2016-03-02  4003  	void (*sync_rx_queues)(struct ieee80211_hw *hw);
708d50edb1 Ayala Beker            2016-09-20  4004  
708d50edb1 Ayala Beker            2016-09-20  4005  	int (*start_nan)(struct ieee80211_hw *hw,
708d50edb1 Ayala Beker            2016-09-20  4006  			 struct ieee80211_vif *vif,
708d50edb1 Ayala Beker            2016-09-20  4007  			 struct cfg80211_nan_conf *conf);
708d50edb1 Ayala Beker            2016-09-20  4008  	int (*stop_nan)(struct ieee80211_hw *hw,
708d50edb1 Ayala Beker            2016-09-20  4009  			struct ieee80211_vif *vif);
5953ff6d6a Ayala Beker            2016-09-20  4010  	int (*nan_change_conf)(struct ieee80211_hw *hw,
5953ff6d6a Ayala Beker            2016-09-20  4011  			       struct ieee80211_vif *vif,
5953ff6d6a Ayala Beker            2016-09-20  4012  			       struct cfg80211_nan_conf *conf, u32 changes);
167e33f4f6 Ayala Beker            2016-09-20  4013  	int (*add_nan_func)(struct ieee80211_hw *hw,
167e33f4f6 Ayala Beker            2016-09-20  4014  			    struct ieee80211_vif *vif,
167e33f4f6 Ayala Beker            2016-09-20  4015  			    const struct cfg80211_nan_func *nan_func);
167e33f4f6 Ayala Beker            2016-09-20  4016  	void (*del_nan_func)(struct ieee80211_hw *hw,
167e33f4f6 Ayala Beker            2016-09-20  4017  			    struct ieee80211_vif *vif,
167e33f4f6 Ayala Beker            2016-09-20  4018  			    u8 instance_id);
9739fe29a2 Sara Sharon            2018-09-05  4019  	bool (*can_aggregate_in_amsdu)(struct ieee80211_hw *hw,
9739fe29a2 Sara Sharon            2018-09-05  4020  				       struct sk_buff *head,
9739fe29a2 Sara Sharon            2018-09-05  4021  				       struct sk_buff *skb);
bc847970f4 Pradeep Kumar Chitrapu 2018-10-03  4022  	int (*get_ftm_responder_stats)(struct ieee80211_hw *hw,
bc847970f4 Pradeep Kumar Chitrapu 2018-10-03  4023  				       struct ieee80211_vif *vif,
bc847970f4 Pradeep Kumar Chitrapu 2018-10-03  4024  				       struct cfg80211_ftm_responder_stats *ftm_stats);
cee7013be9 Johannes Berg          2018-10-16  4025  	int (*start_pmsr)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
cee7013be9 Johannes Berg          2018-10-16  4026  			  struct cfg80211_pmsr_request *request);
cee7013be9 Johannes Berg          2018-10-16  4027  	void (*abort_pmsr)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
cee7013be9 Johannes Berg          2018-10-16  4028  			   struct cfg80211_pmsr_request *request);
f0706e828e Jiri Benc              2007-05-05 @4029  };
f0706e828e Jiri Benc              2007-05-05  4030  

:::::: The code at line 4029 was first introduced by commit
:::::: f0706e828e96d0fa4e80c0d25aa98523f6d589a0 [MAC80211]: Add mac80211 wireless stack.

:::::: TO: Jiri Benc <jbenc@suse.cz>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--r5Pyd7+fXNt84Ff3
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
AA==

--r5Pyd7+fXNt84Ff3--
