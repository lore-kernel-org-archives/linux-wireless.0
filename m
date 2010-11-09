Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55350 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752344Ab0KISyh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 13:54:37 -0500
Message-ID: <4CD9922C.2030609@openwrt.org>
Date: Tue, 09 Nov 2010 19:25:48 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Wojciech Dubowik <dubowoj@neratec.com>
CC: linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: Re: DFS implementation in mac80211
References: <17252874.311288606699683.JavaMail.wlan@CHBU500181>
In-Reply-To: <17252874.311288606699683.JavaMail.wlan@CHBU500181>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-01 11:18 AM, Wojciech Dubowik wrote:
> Hello,
> Our company has started implementation of Dynamic Frequency Selection
> in current linux wireless drivers. We have got basic radar detection
> part working. It has been tested with software based pulse
> simulator.
Nice!

> The question is on how to integrate it with mac80211. Pulse detection
> has to be done deep in specific driver but decision making can be
> shifted to either mac80211 or higher into user space. Current ETSI
> specification allows up to 1 second time for changing channel so it
> doesn't need to be real time. Has anyone put already some thoughts on
> where to implement available channel list management, radar table
> handling, etc. and what would be the interface?
I think it would make sense to put this into mac80211. Could you please
post your implementation somewhere? Might make it easier to figure out
how to integrate it properly.
I'm interested in working on this as well (I have some pending patches
for ath9k DFS pulse pattern reporting), but my available time is very
limited right now.

Thanks,

- Felix
