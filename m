Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:59656 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab0ESP5D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 11:57:03 -0400
Message-ID: <4BF40A3F.2040902@openwrt.org>
Date: Wed, 19 May 2010 17:56:47 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jussi Haakana <Jussi.Haakana@7signal.com>
CC: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Add a missing null pointer check
References: <0290AB2F0A8E124B9FFC144088A1A95609D6AA414B@EX-MBS04.nbl.local>
In-Reply-To: <0290AB2F0A8E124B9FFC144088A1A95609D6AA414B@EX-MBS04.nbl.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-05-19 12:27 PM, Jussi Haakana wrote:
> If a network interface is down while setting a channel,
> missing null pointer check causes an oops in cfg80211_set_freq:
> 
> # iw phy phy0 interface add ath1 type monitor
> # iw dev ath1 set channel 3
> Unable to handle kernel paging request for data at address 0x00000004
> Faulting instruction address: 0xca16d778
> Oops: Kernel access of bad area, sig: 11 [#1]
> ...
> 
> Signed-off-by: Jussi Haakana <Jussi.Haakana@7signal.com>
That's exactly what I sent 4 days ago ;)

- Felix
