Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60234 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750876AbdBBHoP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 02:44:15 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: kbuild test robot <lkp@intel.com>
CC: "Nagarajan, Ashok Raj" <arnagara@qti.qualcomm.com>,
        "arnagara@codeaurora.org" <arnagara@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kbuild-all@01.org" <kbuild-all@01.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: add support for controlling tx power to a
 station
Date: Thu, 2 Feb 2017 07:44:00 +0000
Message-ID: <877f59ox56.fsf@kamboji.qca.qualcomm.com> (sfid-20170202_084553_148753_2833494B)
References: <201702010556.QVNevZKo%fengguang.wu@intel.com>
In-Reply-To: <201702010556.QVNevZKo%fengguang.wu@intel.com> (kbuild test
        robot's message of "Wed, 1 Feb 2017 05:54:43 +0800")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> Hi Ashok,
>
> [auto build test WARNING on ath6kl/ath-next]
> [also build test WARNING on v4.10-rc6 next-20170131]
> [if your patch is applied to the wrong git tree, please drop us a note to=
 help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Ashok-Raj-Nagarajan/ath1=
0k-add-support-for-controlling-tx-power-to-a-station/20170201-032529
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath=
-next
> config: m68k-allyesconfig (attached as .config)
> compiler: m68k-linux-gcc (GCC) 4.9.0
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.g=
it/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=3Dm68k=20
>
> All warnings (new ones prefixed by >>):
>
>    drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_sta_set_txp=
wr':
>    drivers/net/wireless/ath/ath10k/mac.c:5997:13: error: 'struct ieee8021=
1_sta' has no member named 'txpwr'
>      txpwr =3D sta->txpwr;
>                 ^
>    drivers/net/wireless/ath/ath10k/mac.c: At top level:
>    drivers/net/wireless/ath/ath10k/mac.c:7581:2: error: unknown field 'st=
a_set_txpwr' specified in initializer
>      .sta_set_txpwr   =3D ath10k_sta_set_txpwr,
>      ^

This is expected as this patch depends on a mac80211 feature not yet
applied.

--=20
Kalle Valo=
