Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:61134 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbZLNGQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 01:16:05 -0500
Received: by ey-out-2122.google.com with SMTP id d26so783422eyd.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Dec 2009 22:16:03 -0800 (PST)
To: Satanand Burla <Satanand_Burla@phoenix.com>
Cc: "ath9k-devel\@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k ps poll performance
References: <6D80BDFB1A1FA74DA476417C24C452A10251AB5773@scl-exch2k7.phoenix.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 14 Dec 2009 08:16:00 +0200
In-Reply-To: <6D80BDFB1A1FA74DA476417C24C452A10251AB5773@scl-exch2k7.phoenix.com> (Satanand Burla's message of "Sat\, 12 Dec 2009 14\:58\:12 -0800")
Message-ID: <871viy13of.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Satanand Burla <Satanand_Burla@phoenix.com> writes:

> for example with the same wep AP, I get around 150 to 200 Kbps
> without enabling ps poll.

That's very low. What kind of test are you using here?

> but if I enable ps poll with the above settings, I get only around
> 20 Kbps and the packet loss is around 20 to 30%.
>
> My question is, is this the expected speed drop when turning on ps
> poll ? Or is this a problem with the driver that still needs to be
> addressed ?

With PS-Poll (ie. timeout is zero) you should still get in range of
megabits per second and no packet loss. So something is wrong.

-- 
Kalle Valo
