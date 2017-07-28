Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:26040 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751633AbdG1Pzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 11:55:45 -0400
Date: Fri, 28 Jul 2017 23:55:42 +0800
From: kbuild test robot <lkp@intel.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: Re: [PATCH 32/34] brcmfmac: Replace function index with function
 pointer
Message-ID: <201707282310.BzvLNSlV%fengguang.wu@intel.com> (sfid-20170728_175553_876342_973FFE65)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170726202557.15632-33-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ian,

[auto build test WARNING on wireless-drivers-next/master]
[also build test WARNING on v4.13-rc2 next-20170728]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Ian-Molton/brcmfmac-Fix-parameter-order-in-brcmf_sdiod_f0_writeb/20170728-215756
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:316:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
