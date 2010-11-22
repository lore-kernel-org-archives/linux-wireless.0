Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sdinet.de ([78.47.32.153]:53132 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab0KVRKA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 12:10:00 -0500
Date: Mon, 22 Nov 2010 18:02:09 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Klaas De Craemer <klaasdc@gmail.com>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
In-Reply-To: <4CEA9903.6070604@lwfinger.net>
Message-ID: <alpine.DEB.2.02.1011221759150.30015@aurora.sdinet.de>
References: <AANLkTi=gzBDd6AZAzUKpLyTxtOgkwUkB5STeaU45=OFB@mail.gmail.com> <4CE997E3.9080706@lwfinger.net> <AANLkTi=kF956KYU393jmZhMagX=mz6dZcf1xwMaqPJ3Q@mail.gmail.com> <4CEA9903.6070604@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 22 Nov 2010, Larry Finger wrote:

> On 11/22/2010 02:59 AM, Klaas De Craemer wrote:
> > 
> > Sorry, I meant I get a few errors in the form of "SIOCSIFFLAGS:
> > Unknown error 132" on the stdout when trying to bring up the blocked
> > interface.
> 
> Do those errors also occur when it works, or just when it is blocked?

Just a small side note:
I receive the same error message for "ifconfig wlan0 up" whenever rfkill 
is active for a wlan device - using iwl3945 and iwlagn here.

So I would not look too deep into this message in case rfkill is on.

(Not that we could not use a better error message in this case, or 
perhaps just also a printk - took me quite a while to figure it out at 
first)

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
