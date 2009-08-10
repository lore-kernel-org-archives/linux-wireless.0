Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52760 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbZHJMwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 08:52:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [RFC PATCH] b43: Implement LP-PHY baseband table initialization
Date: Mon, 10 Aug 2009 14:52:49 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A7F713E.8040405@gmail.com> <200908101441.43480.mb@bu3sch.de> <69e28c910908100549w6af5bd12j568c7f0c2aa31e30@mail.gmail.com>
In-Reply-To: <69e28c910908100549w6af5bd12j568c7f0c2aa31e30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908101452.50072.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 August 2009 14:49:31 Gábor Stefanik wrote:
> 2009/8/10 Michael Buesch <mb@bu3sch.de>:
> > On Monday 10 August 2009 03:00:46 Gábor Stefanik wrote:
> >> +static const u16 lpphy_sw_control_table[] = {
> >> +     0x0128,
> >> +     0x0128,
> >> +     0x0009,
> >> +     0x0009,
> >> +     0x0028,
> >> +     0x0028,
> >
> > Is it possible to use more than one value per line for all these tables?
> > Make sure to make best use of the 80 columns limit.
> > This would significantly decrease the patch/file length. (linewise)
> >
> > --
> > Greetings, Michael.
> >
> 
> Well, I converted the tables directly from the Wikitext on
> bcm-v4.sipsolutions.net using regex search&replace - if you know a
> good regex to convert the tables to use multiple values on each line,
> please post it.
> 

I have some hacky python scripts to parse and reformat these tables.
I will post them in a few hours. I'll have to leave now. brb.

-- 
Greetings, Michael.
