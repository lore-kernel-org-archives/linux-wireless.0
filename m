Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:44967 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab2BYT23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 14:28:29 -0500
Received: by werb13 with SMTP id b13so2075031wer.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Feb 2012 11:28:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F4772AB.9000305@posedge.com>
References: <f17c700977012ada368da4f339b9c639@posedge.com>
	<1329933458.4657.2.camel@jlt3.sipsolutions.net>
	<1329937072.4657.4.camel@jlt3.sipsolutions.net>
	<4F471F40.8060503@posedge.com>
	<1330070145.3426.8.camel@jlt3.sipsolutions.net>
	<4F4772AB.9000305@posedge.com>
Date: Sat, 25 Feb 2012 11:22:58 -0800
Message-ID: <CAJ-VmomfVCc0oQMjfwsrheC+Z2k3+-czo4F9GeeO=upHiHnQxg@mail.gmail.com> (sfid-20120225_202833_345255_DD58598C)
Subject: Re: [RFCv2] cfg80211: 80Mhz Bandwidth channel flags in 5Gig band
From: Adrian Chadd <adrian@freebsd.org>
To: Mahesh <maheshp@posedge.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Chakra Parvathaneni <chakra@posedge.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. and this doesn't yet address VHT160, which is part of the 11ac spec too.

I think it's worth having a bit more of a total, overall architecture
discussion about what 11ac support -should- look like before bits are
comitted, so you don't have to go and change them later (and possibly
break some internal company drivers whilst doing so.)

So - what else is likely needed for the upcoming 11ac standard?

Disclaimer: I'm speaking from my personal opinion rather than that of
Qualcomm Atheros.



adrian
