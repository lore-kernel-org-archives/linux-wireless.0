Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbYGaN52 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 09:57:28 -0400
Subject: Re: Driver for the FullMAC card
From: Dan Williams <dcbw@redhat.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <g6qr98$q28$2@ger.gmane.org>
References: <g6qr98$q28$2@ger.gmane.org>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 09:54:48 -0400
Message-Id: <1217512488.12016.8.camel@localhost.localdomain> (sfid-20080731_155730_374440_BC9E0167)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-30 at 22:51 +0000, Dmitry Baryshkov wrote:
> Hi,
> 
> I'd like to work on the Prism2 USB driver (currently maintained as a part of
> wlan-ng project) to be able to push it into mainline. The card itself is
> a FullMAC card. Where should I start? What parts of 802.11 stacks/API
> should I use? There is plenty of information regarding SoftMAC drivers,
> but no clear pointers for developing drivers for the FullMAC cards.

If you're talking about the same hardware that linux-wlan-ng supported
(ie, what Ubuntu ships as prism2_usb) then that hardware can be softmac,
actually.  We discussed this a while ago and agreed that a completely
new mac80211-based driver for this hardware was the best way to go,
rather than trying to stuff USB support into hostap.

If that's not the hardware we're talking about, can you give me some
examples of the brand and model of devices this would drive?  Are we
talking about stuff like the Netgear MA111 (FCC ID PY3MA111) here?

Dan

