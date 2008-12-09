Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:39649 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbYLINOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 08:14:52 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: Fix HT channel selection
Date: Tue, 9 Dec 2008 13:14:34 +0000
Cc: Mats Johannesson <spamcan1@abrasax.se>,
	Sujith <m.sujith@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni.Malinen@atheros.com
References: <20081209135456.68778e51@loke.fish.not>
In-Reply-To: <20081209135456.68778e51@loke.fish.not>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812091314.34169.hs4233@mail.mn-solutions.de> (sfid-20081209_141457_891863_044EE048)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 13:30:16 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0

Why the useless brackets?

And is it by intent that this uses frequencies and not channel numbers?
I personally tend to be much more able to remember channels, but
frequencies are more versatile.
