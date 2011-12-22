Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64752 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1LVMjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 07:39:20 -0500
Received: by wgbdr13 with SMTP id dr13so15834870wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 04:39:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EF31325.2050408@openwrt.org>
References: <CAApCBGx28SbbmNpynCpKW9CyAsV5+c_fZ=1k9QAsKnXf4nDQEw@mail.gmail.com>
	<CAApCBGx7fHuQr87TnppE6FyX9d-1F0huUqgYhjv++8vmfov6zQ@mail.gmail.com>
	<4EF31325.2050408@openwrt.org>
Date: Thu, 22 Dec 2011 14:39:19 +0200
Message-ID: <CAApCBGwto0YxMKcirX_FJYaGw8K6Dcoxpn9P30=Mk-9oHJok+Q@mail.gmail.com> (sfid-20111222_133924_424046_ACC2A318)
Subject: Re: ar9390 failing AGC calibration on powerpc platform
From: wireless newbie <wnewbie72@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Mohammed Shafi <shafi.wireless@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Have you tried any other PCIe device behind such a bridge?
>

I have tested some gigabit ethernet cards an they work just fine. I
also tried another wlan card that has other atheros chip in it but
uses same ath9k driver. It works better, but that card too has
problems. Lots of phy and rx errors and poor throughput.
