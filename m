Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:26379 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbYLINdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 08:33:23 -0500
Received: by ti-out-0910.google.com with SMTP id b6so1060136tic.23
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2008 05:33:21 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18750.29471.106723.987402@localhost.localdomain> (sfid-20081209_143332_857121_A6CE6EB8)
Date: Tue, 9 Dec 2008 19:01:11 +0530
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	Mats Johannesson <spamcan1@abrasax.se>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni.Malinen@atheros.com
Subject: Re: [RFC v2] mac80211: Fix HT channel selection
In-Reply-To: <200812091314.34169.hs4233@mail.mn-solutions.de>
References: <20081209135456.68778e51@loke.fish.not>
	<200812091314.34169.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig wrote:
> > 13:30:16 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
> 
> Why the useless brackets?
> 

No reason, actually. :)

> And is it by intent that this uses frequencies and not channel numbers?
> I personally tend to be much more able to remember channels, but
> frequencies are more versatile.

Nope, no intent here. :)

Sujith
