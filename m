Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34230 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbbG1OcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 10:32:12 -0400
Received: by wibud3 with SMTP id ud3so183557647wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 07:32:10 -0700 (PDT)
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [RFC 0/4] mac80211: define VHT rate mask logic
Message-ID: <55B79267.9020706@gmail.com> (sfid-20150728_163215_146762_F7CC26BB)
Date: Tue, 28 Jul 2015 16:32:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi wrote:

> [...]
> This patchset has been tested using mac80211/mt76 driver on
> Buffalo WHR-1166D router running OpenWrt trunk

mt76 is an out of the tree driver, included only in OpenWrt.

Maybe OpenWrt people should begin sending code to upstream,
because their tree [1] is full of patches [2] .

[1] http://git.openwrt.org/?p=openwrt.git
[2] target/linux/* (target/linux/generic/patches-* specifically)
    and package/kernel/* (package/kernel/mac80211/* for wireless)
