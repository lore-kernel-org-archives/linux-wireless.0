Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:50563 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab0FZRv5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jun 2010 13:51:57 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org
Date: Sat, 26 Jun 2010 19:54:17 +0200
MIME-Version: 1.0
Subject: Re: ATH5k - Signal measurement reports wrong values - thanks for a fix
Message-ID: <4C263EC9.12342.C4FBB@jafojtik.seznam.cz>
In-reply-to: <201006270107.59150.br1@einfach.org>
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz>, <4C25F603.29925.1365B7A@jafojtik.seznam.cz>, <201006270107.59150.br1@einfach.org>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Bruno,

> > If it is not, please Email me such patch.
> 
> i dont have it here right now, but i sent it in a previous reply to you:
> 
> http://marc.info/?l=linux-wireless&m=127717933410893&w=2
> 
> it's just one line, so you can also change the same line in your compat-
> wireless source code.
Yes, I have patched it now.


> > I am currently using compat-wireless-2010-06-22 and it is still affected by
> > wrong signal measurement.
> 
> yes, my patch is not part of compat-wireless yet. if you confirm that it fixes 
> your problem i will send it for inclusion.
It looks, that your patch really returns back proper signal values.

I will not poison Email with png files, feel free to look at here:
  http://78.108.103.11:11080/cgi-bin/rodga_1day_big.cgi
Magenta line returned back to green line from other direction.


Even in an AP mode the magenta line also jumped to expected value:
  http://78.108.103.11:11080/tmp/klienti-day-big.png

I hope that this patch would not influence performance or any other
functionality.

regards
   Jara


>  
> bruno


