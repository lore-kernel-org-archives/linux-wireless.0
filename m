Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57312 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750880AbdKWHmS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Nov 2017 02:42:18 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: Felix Fietkau <nbd@nbd.name>, kbuild-all@01.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7 3/3] mt76: add driver code for MT76x2e
References: <20171120193549.80831-4-nbd@nbd.name>
        <201711231440.jGwH44nB%fengguang.wu@intel.com>
Date: Thu, 23 Nov 2017 09:42:13 +0200
In-Reply-To: <201711231440.jGwH44nB%fengguang.wu@intel.com> (kbuild test
        robot's message of "Thu, 23 Nov 2017 15:05:04 +0800")
Message-ID: <871skpa1be.fsf@kamboji.qca.qualcomm.com> (sfid-20171123_084221_957009_32F60F92)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> I love your patch! Yet something to improve:
>
> [auto build test ERROR on wireless-drivers-next/master]
> [also build test ERROR on v4.14 next-20171122]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Felix-Fietkau/dt-bindings-net-add-mt76-wireless-device-binding/20171123-125723
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> config: tile-allyesconfig (attached as .config)
> compiler: tilegx-linux-gcc (GCC) 4.6.2
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=tile 
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c: In function 'mt76x2_mac_process_rate':
>    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:49:20: error: 'RX_FLAG_SHORTPRE' undeclared (first use in this function)
>    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:49:20: note: each undeclared identifier is reported only once for each function it appears in
>    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:58:19: error: 'RX_FLAG_HT_GF' undeclared (first use in this function)
>    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:61:19: error: 'RX_FLAG_HT' undeclared (first use in this function)
>    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:65:19: error: 'RX_FLAG_VHT' undeclared (first use in this function)
>    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:67:9: error: 'struct ieee80211_rx_status' has no member named 'vht_nss'
>    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:75:19: error: 'RX_FLAG_LDPC' undeclared (first use in this function)
>    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:78:19: error: 'RX_FLAG_SHORT_GI' undeclared (first use in this function)
>    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:81:24: error: 'RX_FLAG_STBC_SHIFT' undeclared (first use in this function)
>    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:87:19: error: 'RX_FLAG_40MHZ' undeclared (first use in this function)
>>> drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:90:9: error: 'struct ieee80211_rx_status' has no member named 'vht_flag'
>    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:90:23: error: 'RX_VHT_FLAG_80MHZ' undeclared (first use in this function)

Felix fixed these in v8.

-- 
Kalle Valo
