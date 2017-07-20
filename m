Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:46016 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S936694AbdGTRpR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Jul 2017 13:45:17 -0400
Subject: Re: [PATCH 28/29] brcmfmac: Rename buscore->core for consistency
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
References: <201707201435.jvP0aU47%fengguang.wu@intel.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <211aceb1-0b4e-039f-f874-0e4ea8073172@mnementh.co.uk> (sfid-20170720_194539_001719_3E0E8637)
Date: Thu, 20 Jul 2017 18:45:13 +0100
MIME-Version: 1.0
In-Reply-To: <201707201435.jvP0aU47%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20/07/17 08:00, kbuild test robot wrote:
> Hi Ian,
> 
> [auto build test WARNING on wireless-drivers-next/master]
> [also build test WARNING on v4.13-rc1]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Ian-Molton/brcmfmac-Fix-parameter-order-in-brcmf_sdiod_f0_writeb/20170718-123057
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> config: x86_64-randconfig-a0-07201347 (attached as .config)
> compiler: gcc-4.4 (Debian 4.4.7-8) 4.4.7
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c: In function 'brcmf_sdio_intr_rstatus':
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:2470: warning: unused variable 'addr'

Fixed in v3 spin of this series.
