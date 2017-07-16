Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:64327 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751223AbdGPPRR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 11:17:17 -0400
Date: Sun, 16 Jul 2017 23:16:53 +0800
From: kbuild test robot <lkp@intel.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: Re: [PATCH 17/21] brcmfmac: HUGE cleanup of IO access functions.
Message-ID: <201707162358.x6v6RcNt%fengguang.wu@intel.com> (sfid-20170716_171721_740547_3B067E75)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170716112129.10206-18-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ian,

[auto build test WARNING on wireless-drivers/master]
[also build test WARNING on v4.13-rc1 next-20170714]
[cannot apply to wireless-drivers-next/master]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Ian-Molton/net-brcmfmac-Write-function-depends-on-size-of-regs-not-types/20170716-195206
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:283:9-10: WARNING: return of 0/1 in function 'brcmf_chip_axi_iscoreup' with return type bool

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
