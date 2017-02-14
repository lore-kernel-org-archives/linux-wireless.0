Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61519 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753116AbdBNPFv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 10:05:51 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: kbuild test robot <lkp@intel.com>
CC: "Nagarajan, Ashok Raj" <arnagara@qti.qualcomm.com>,
        "arnagara@codeaurora.org" <arnagara@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kbuild-all@01.org" <kbuild-all@01.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v3] ath10k: add support for controlling tx power to a
 station
Date: Tue, 14 Feb 2017 15:05:45 +0000
Message-ID: <87zihoq0ce.fsf@kamboji.qca.qualcomm.com> (sfid-20170214_160555_434734_A4F1383E)
References: <201702120825.pCIZZp0b%fengguang.wu@intel.com>
In-Reply-To: <201702120825.pCIZZp0b%fengguang.wu@intel.com> (kbuild test
        robot's message of "Sun, 12 Feb 2017 08:17:48 +0800")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> Hi Ashok,
>
> [auto build test ERROR on v4.9-rc8]
> [cannot apply to ath6kl/ath-next next-20170210]
> [if your patch is applied to the wrong git tree, please drop us a note to=
 help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Ashok-Raj-Nagarajan/ath1=
0k-add-support-for-controlling-tx-power-to-a-station/20170208-203305
> config: x86_64-randconfig-in0-02120025 (attached as .config)
> compiler: gcc-4.6 (Debian 4.6.4-7) 4.6.4
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=3Dx86_64=20
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_sta_set_txp=
wr':
>>> drivers/net/wireless/ath/ath10k/mac.c:5900:10: error: 'struct
>>> ieee80211_sta' has no member named 'txpwr'
>    drivers/net/wireless/ath/ath10k/mac.c: At top level:
>>> drivers/net/wireless/ath/ath10k/mac.c:7469:2: error: unknown field
>>> 'sta_set_txpwr' specified in initializer
>    drivers/net/wireless/ath/ath10k/mac.c:7469:2: warning:
> initialization from incompatible pointer type [enabled by default]
>    drivers/net/wireless/ath/ath10k/mac.c:7469:2: warning: (near
> initialization for 'ath10k_ops.sta_pre_rcu_remove') [enabled by
> default]
>    drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_mac_registe=
r':
>>> drivers/net/wireless/ath/ath10k/mac.c:8008:11: error:
>>> 'NL80211_EXT_FEATURE_STA_TX_PWR' undeclared (first use in this
>>> function)

These are expected as this depends on cfg80211 patch not yet applied.

--=20
Kalle Valo=
