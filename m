Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62226 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752112AbdK1Ojd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Nov 2017 09:39:33 -0500
Message-ID: <1511879969.4011.435.camel@intel.com> (sfid-20171128_153936_880769_8FC14AB3)
Subject: Re: [PATCH 08/11] iwlwifi: mvm: Add debugfs support for FTM
 initiator fields
From: Luciano Coelho <luciano.coelho@intel.com>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, Adiel Aloni <adiel.aloni@intel.com>
Date: Tue, 28 Nov 2017 16:39:29 +0200
In-Reply-To: <201711282154.dLWMuU7H%fengguang.wu@intel.com>
References: <20171125163444.24258-9-luca@coelho.fi>
         <201711282154.dLWMuU7H%fengguang.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-11-28 at 21:34 +0800, kbuild test robot wrote:
> Hi Adiel,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on wireless-drivers-next/master]
> [also build test ERROR on v4.15-rc1 next-20171128]
> [if your patch is applied to the wrong git tree, please drop us a
> note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Luca-Coelho/iwlwifi-
> updates-intended-for-v4-16-2017-11-25/20171128-205312
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireles
> s-drivers-next.git master
> config: x86_64-randconfig-x011-201748 (attached as .config)
> compiler: gcc-7 (Debian 7.2.0-12) 7.2.1 20171025
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c: In function
> 'iwl_dbgfs_tof_range_request_write':
> > > drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c:957:27:
> > > error: 'struct iwl_tof_range_req_cmd' has no member named
> > > 'common_calib'
> 
>        mvm->tof_data.range_req.common_calib =

Ouch, for some reason I didn't have debugfs enabled in my .config and
missed this.

This patch depends on some code that is not upstream yet, so I'll just
remove it for now.

--
Cheers,
Luca.
