Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36182 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751319AbdARIBp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 03:01:45 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        kbuild-all@01.org, Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH] brcmfmac: use wiphy_read_of_freq_limits to respect limits from DT
References: <201701181250.KMcvYlf0%fengguang.wu@intel.com>
Date: Wed, 18 Jan 2017 10:01:22 +0200
In-Reply-To: <201701181250.KMcvYlf0%fengguang.wu@intel.com> (kbuild test
        robot's message of "Wed, 18 Jan 2017 12:55:16 +0800")
Message-ID: <871sw0okz1.fsf@kamboji.qca.qualcomm.com> (sfid-20170118_090151_696227_8DF1BD00)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> Hi Rafa=C5=82,
>
> [auto build test ERROR on wireless-drivers-next/master]
> [cannot apply to v4.10-rc4 next-20170117]
> [if your patch is applied to the wrong git tree, please drop us a note to=
 help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/brcmfmac-us=
e-wiphy_read_of_freq_limits-to-respect-limits-from-DT/20170118-122222
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-dr=
ivers-next.git master
> config: x86_64-randconfig-x013-201703 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=3Dx86_64=20
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c: In functi=
on 'brcmf_setup_wiphy':
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:6484:2: err=
or: implicit declaration of function 'wiphy_read_of_freq_limits' [-Werror=
=3Dimplicit-function-declaration]
>      wiphy_read_of_freq_limits(wiphy);
>      ^~~~~~~~~~~~~~~~~~~~~~~~~

The compiler error is expected as this depends on a cfg80211 patch not
yet in wireless-drivers-next.

--=20
Kalle Valo
