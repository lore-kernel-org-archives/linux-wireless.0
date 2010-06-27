Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:41265 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab0F0H0A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jun 2010 03:26:00 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org
Date: Sun, 27 Jun 2010 09:28:17 +0200
MIME-Version: 1.0
Subject: Re: ATH5k - Signal measurement reports wrong values - thanks for a fix
Message-ID: <4C26FD91.10140.F4D6B@jafojtik.seznam.cz>
In-reply-to: <201006271120.11785.br1@einfach.org>
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz>, <4C263EC9.12342.C4FBB@jafojtik.seznam.cz>, <201006271120.11785.br1@einfach.org>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Bruno,

> > I hope that this patch would not influence performance or any other
> > functionality.
> no it just fixes a regression i have introduced in an earlier change. thanks 
> for reporting and testing this! i will send the patch for inclusion on monday, 
> then it might take some time (few days to weeks) until it apperars in compat-
> wireless.

Thank you for explanation.
The patch surely improves signal strength measurement and I recomend it.

Anyway, when you look at the magenta line here:
  http://78.108.103.11:11080/cgi-bin/rodga_1day_big.cgi

There are big drops in measured signal. Did you fix all places?

Before this patch there were short peeks from -78dB to -71dB. 
After patch there are short measurement drops from -62dB to -70dB.

The week charting simply averages it:
  http://78.108.103.11:11080/cgi-bin/rodga_1week_big.cgi

regards
   Jara



> 
> bruno
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


