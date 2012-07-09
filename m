Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65192 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2GITSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 15:18:20 -0400
Received: by eaak11 with SMTP id k11so4451505eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 12:18:19 -0700 (PDT)
Message-ID: <4FFB2E78.9090402@gmail.com> (sfid-20120709_211824_085263_322A29E8)
Date: Mon, 09 Jul 2012 21:18:16 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: thomas@net.t-labs.tu-berlin.de, x-alina@gmx.net, nbd@openwrt.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Add transmit power control support (TPC)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Huehn wrote:

> (6) restructure tx-path of all effected drivers
> Restructure tx-path of all effected drivers to respect new TPC support in
> mac80211. TPC support is added to mac80211 by restructuring of struct
> ieee80211_tx_info. Therfore the tx-path of all effected drivers is modified
> to receive struct sta from the stack and respect the new ieee80211_tx_info
> struct. List of modified driver:

> ath9k
> ath5k
> iwl3954
> iwl4965
> iwl-agn
> mwl8k
> carl9170
> ath9k-htc
> p54
> rt2x00
> rtl8180
> rtl8087
> hwsim
> b43
> b43legacy
> brcmsmac
> zd1211rw

candidates:

ath6kl
brcmfmac
iwmc3200wifi
libertas_tf
mwifiex
rndis_wlan
rtlwifi
wl1251
wl12xx
