Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39578 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824Ab0BNTLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 14:11:32 -0500
Date: Sun, 14 Feb 2010 21:11:26 +0200
From: Jouni Malinen <j@w1.fi>
To: =?utf-8?B?R8OhYm9y?= Stefanik <netrolller.3d@gmail.com>
Cc: Neshama Parhoti <pneshama@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: good wlan: sniffer that does not need a windows machine ?
Message-ID: <20100214191126.GA13637@jm.kir.nu>
References: <912ec82a1002140957p6959c030h2b33fd9646cfd67d@mail.gmail.com>
 <69e28c911002141046r70d8bcf2g6a8db7afbbef837@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <69e28c911002141046r70d8bcf2g6a8db7afbbef837@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 14, 2010 at 07:46:04PM +0100, Gábor Stefanik wrote:
> Monitoring in general works in almost all linux drivers (the Alfa
> AWUS036H is perhaps the best for this purpose) - however, there is no
> known way to monitor 802.11n packets on Linux (due to problems with
> the mac80211 stack not passing 802.11n frames to monitor interfaces?).

Known to whom? ;-) mac80211 passes 802.11n packet just fine to monitor
interfaces and as an example, I'm using ath9k as a wireless sniffer for
IEEE 802.11g/a/n. The radiotap headers may not show all parameters at
this point, but there is ongoing work to extend that 

> Currently, the only way to sniff 802.11n packets is the AirPcap NX on
> Windows.

Yeah, right..

-- 
Jouni Malinen                                            PGP id EFC895FA
