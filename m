Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20896 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbYBGNfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 08:35:25 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Getting Started
Date: Thu, 7 Feb 2008 14:35:17 +0100
References: <912ec82a0802070511y734f9836q244abb7800210961@mail.gmail.com>
In-Reply-To: <912ec82a0802070511y734f9836q244abb7800210961@mail.gmail.com>
Cc: "Neshama Parhoti" <pneshama@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802071435.17254.hs4233@mail.mn-solutions.de> (sfid-20080207_133529_614669_B6A54633)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Can you please point me to known good knowledge
> references/overviews/tutorials on the subject ?

Get a linux kernel via git. Look at the drivers in 
drivers/net/wireless. Some of them use mac80211, you can find 
out which one by looking at Kconfig there, e.g. when they have a 
line "depends on MAC80211" there.

Those existing drivers should be a great inspiration to you :-)


It also helps when you share more about your incentives. E.g. 
writing 

> I'm about to write a new driver for mac80211.

doesn't give a great deal of insight into what you're up to. 
Maybe someone else already begin to write a driver for your 
hardware ?!?!  No one can tell you this right now, so you can't 
possibly save work on your side.

For example, the openmoko people are writing a mac80211 driver 
for ar6k. Not every driver is already in the wireless-2.6 git 
tree.
