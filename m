Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54024 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751948AbcIPD4r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 23:56:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: Colin King <colin.king@canonical.com>, kbuild-all@01.org,
        Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mwifiex: fix null pointer deference when adapter is null
References: <201609160029.fRGnTGuA%fengguang.wu@intel.com>
Date: Fri, 16 Sep 2016 06:56:39 +0300
In-Reply-To: <201609160029.fRGnTGuA%fengguang.wu@intel.com> (kbuild test
        robot's message of "Fri, 16 Sep 2016 00:29:25 +0800")
Message-ID: <87r38ka45k.fsf@kamboji.qca.qualcomm.com> (sfid-20160916_055705_123329_A6B96DB7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> url:    https://github.com/0day-ci/linux/commits/Colin-King/mwifiex-fix-null-pointer-deference-when-adapter-is-null/20160915-231625
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> config: x86_64-randconfig-x013-201637 (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
>
> All warnings (new ones prefixed by >>):
>
>    drivers/net/wireless/marvell/mwifiex/main.c: In function 'mwifiex_shutdown_sw':
>>> drivers/net/wireless/marvell/mwifiex/main.c:1433:1: warning: label 'exit_remove' defined but not used [-Wunused-label]
>     exit_remove:
>     ^~~~~~~~~~~

Looks like a valid warning to me, so please resend.

-- 
Kalle Valo
