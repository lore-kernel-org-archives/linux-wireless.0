Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yoda.london.02.net ([82.132.130.151]:52461 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755322Ab1BYQ5t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 11:57:49 -0500
Date: Fri, 25 Feb 2011 16:57:45 +0000
From: Tony Houghton <h@realh.co.uk>
To: Mohammed Shafi <shafi.ath9k@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vivek Natarajan <vnatarajan@atheros.com>
Subject: Re: [ath9k-devel] ath9k causes lockups since kernel 2.6.35
Message-ID: <20110225165745.4860afe0@realh.co.uk>
In-Reply-To: <AANLkTinu9NgnZZmieh2PU6e-iShOkapV9kcVe8YGtPHG@mail.gmail.com>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
	<20110225144718.63550601@realh.co.uk>
	<AANLkTinu9NgnZZmieh2PU6e-iShOkapV9kcVe8YGtPHG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 25 Feb 2011 21:37:25 +0530
Mohammed Shafi <shafi.ath9k@gmail.com> wrote:

> On Fri, Feb 25, 2011 at 8:17 PM, Tony Houghton <h@realh.co.uk> wrote:
> >
> >> >> I haven't tried looking in logs because the crashes are so severe I
> >> >> don't think they'd be able to record anything useful.
> 
> Can you please get those messages with net console ?
> 
> > If I enable debugging is there a way to get it to sync to disc after
> > every message? I think the developers are going to need at least that
> > information to be able to track this down.
> 
> Yes sure, that could narrow down the issue.

I'll try that first because it should be easier than setting up net
console.

> >> is this issue still reproducible ?
> >
> > Yes :-(.
> 
> It would be highly helpful if this issue is reproducible in the latest
> wireless testing or compat wireless. It will help us to fix it cleanly

I think I'll need to rebuild anyway to enable ath9k debugging so I might
as well build whichever version would be most useful to developers. Is
there a particular branch I should pull from? If it's maintained
separately from the main kernel please give me instructions on how to
merge it or whatever, because I'm not very familiar with the kernel or
more advanced git usage.
