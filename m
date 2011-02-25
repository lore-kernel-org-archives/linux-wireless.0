Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vader.london.02.net ([82.132.130.150]:35014 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753713Ab1BYOrR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 09:47:17 -0500
Date: Fri, 25 Feb 2011 14:47:18 +0000
From: Tony Houghton <h@realh.co.uk>
To: Mohammed Shafi <shafi.ath9k@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vivek Natarajan <vnatarajan@atheros.com>
Subject: Re: [ath9k-devel] ath9k causes lockups since kernel 2.6.35
Message-ID: <20110225144718.63550601@realh.co.uk>
In-Reply-To: <AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 25 Feb 2011 13:21:32 +0530
Mohammed Shafi <shafi.ath9k@gmail.com> wrote:

> > Tony Houghton wrote:
> >
> >> With 2.6.37 I can not use suspend on my Compaq/HP 311c (Intel Atom
> >> N270/NVidia Ion LE). Originally the machine just kept locking up without
> >> even blanking the display when I tried to suspend (using the GNOME menu
> >> or by shutting the lid).

[Snip]

The above was from my original message before I worked out that the
problem was in the wireless because disabling and reneabling wireless,
killing the ath9k module etc, would often produce similar crashes, but
suspend seems to do it more consistently.

> >> booting, but it's always a complete lock-up ie the keyboard is
> >> completely responsive, including caps lock, the mouse won't move if the

I meant *un*responsive of course!

> >> I haven't tried looking in logs because the crashes are so severe I
> >> don't think they'd be able to record anything useful.

If I enable debugging is there a way to get it to sync to disc after
every message? I think the developers are going to need at least that
information to be able to track this down.

> is this issue still reproducible ?

Yes :-(.

> Apart from this reporting I have not seen any other  issues for AR9285.

Strange, isn't it. I can't be the only person trying to use a recent
version of Linux on one of these netbooks, but I couldn't find any
similar complaints on Google. Maybe mine has an obscure fault which is
only triggered by a feature supported in the newer kernels.
