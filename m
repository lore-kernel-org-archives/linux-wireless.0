Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ex-fe02.nebula.fi ([188.117.32.118]:23640 "EHLO ex07.nebula.fi"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753844Ab0ETGPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 02:15:34 -0400
From: Jussi Haakana <Jussi.Haakana@7signal.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 20 May 2010 09:15:28 +0300
Subject: RE: [PATCH] cfg80211: Add a missing null pointer check
Message-ID: <0290AB2F0A8E124B9FFC144088A1A95609D6AA42C6@EX-MBS04.nbl.local>
References: <0290AB2F0A8E124B9FFC144088A1A95609D6AA414B@EX-MBS04.nbl.local>
 <4BF40A3F.2040902@openwrt.org>
In-Reply-To: <4BF40A3F.2040902@openwrt.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-05-19 18:57 PM, Felix Fietkau wrote:
> On 2010-05-19 12:27 PM, Jussi Haakana wrote:
> > If a network interface is down while setting a channel,
> > missing null pointer check causes an oops in cfg80211_set_freq:
> >
> > # iw phy phy0 interface add ath1 type monitor
> > # iw dev ath1 set channel 3
> > Unable to handle kernel paging request for data at address 0x00000004
> > Faulting instruction address: 0xca16d778
> > Oops: Kernel access of bad area, sig: 11 [#1]
> > ...
> >
> > Signed-off-by: Jussi Haakana <Jussi.Haakana@7signal.com>
> That's exactly what I sent 4 days ago ;)

Sorry, missed that one :)

- Jussi

