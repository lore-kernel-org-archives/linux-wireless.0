Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out21.sjc.mx.trendmicro.com ([216.99.131.78]:52636 "EHLO
	out21.sjc.mx.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbaLQMEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 07:04:49 -0500
Received: from out13.sjc.mx.trendmicro.com (unknown [216.99.131.50])
	by out21.sjc.mx.trendmicro.com (Postfix) with ESMTP id BE4CCAA83A7
	for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 11:42:57 +0000 (UTC)
Received: from relay04.sjc.mx.trendmicro.com (unknown [10.30.239.25])
	by out13.sjc.mx.trendmicro.com (Postfix) with ESMTP id 31D439816D1
	for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 11:42:55 +0000 (UTC)
Received: from thinktube.com (unknown [111.68.225.247])
	by relay04.sjc.mx.trendmicro.com (Postfix) with ESMTP id C49B398042D
	for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 11:42:53 +0000 (UTC)
Message-ID: <54916C38.80103@thinktube.com> (sfid-20141217_130454_579382_599718C0)
Date: Wed, 17 Dec 2014 11:42:48 +0000
From: Bruno Randolf <br1@thinktube.com>
MIME-Version: 1.0
To: Dani Camps <danicamps81@gmail.com>, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: mac80211 USB adapters with 5GHz support and SMA antenna
References: <CAD3NH5X-neqP-61kP=C2oNPPJTQNBkarae0rh93Hm4qzdpZRew@mail.gmail.com>
In-Reply-To: <CAD3NH5X-neqP-61kP=C2oNPPJTQNBkarae0rh93Hm4qzdpZRew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 12/16/2014 07:09 PM, Dani Camps wrote:
> I am looking for a Wi-Fi adapter with the following specs:
> 
> a) Operates at 5GHz
> b) Supports 802.11n and optionally 802.11ac
> c) USB interface
> d) SMA connector for external antenna(s)
> e) It is supported by mac80211, and supports mesh mode

Me too...

IHMO the best USB based chipset/driver combination is still ath9k_htc
with Atheros AR7010/AR9280 or AR9271, which is rock solid and has very
good thruput (and an open firmware). Unfortunately I have heard it's EOL
but it's still possible to buy them, e.g the "TP-Link TL-WN722N" or
"TP-LINK TL-WN822N"...

I have not found good alternatives yet... So I repeat: Does anyone know
a good USB dongle with a good mac/cfg80211 driver and at least 802.11n
2x2:2 and support for AP and IBSS mode?

It's a shame that vendors like Ralink/MediaTek and Realtek do not work
on decent upstream linux drivers... Instead of wasting time cleaning up
the mess they leave with dozens of incomplete "vendor drivers" they drop
on us - maybe the Linux community should just choose *ONE* modern
(preferrably "ac") and cheap USB chipset and concentrate on writing a
driver for it?

And what about the vendors which are more involved in proper linux
wireless develpment? Qualcom/Atheros, Intel, Broadcom: don't you have
any USB chipsets in line?

bruno

