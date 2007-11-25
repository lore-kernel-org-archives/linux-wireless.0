Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:47115 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbXKYBmg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 20:42:36 -0500
Subject: Re: Belin FD7010 v7
From: Pavel Roskin <proski@gnu.org>
To: Vadim Peretokin <vperetokin@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <6995ca080711241246kbb09472k777c2082a41b692a@mail.gmail.com>
References: <6995ca080711221239t2947765ds765fd933fce5de31@mail.gmail.com>
	 <1195781993.11966.27.camel@dv>
	 <6995ca080711221804w7310134aw8a5902e45aa09942@mail.gmail.com>
	 <1195784707.11966.38.camel@dv>
	 <6995ca080711230736n54330d30s96831a664d46df1c@mail.gmail.com>
	 <1195879405.7449.62.camel@dv>
	 <6995ca080711241054s4aeca1f9r2496a36f93a9db43@mail.gmail.com>
	 <20071124143310.a7pta1f4lc0k4ok0@webmail.spamcop.net>
	 <6995ca080711241246kbb09472k777c2082a41b692a@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 24 Nov 2007 20:42:34 -0500
Message-Id: <1195954954.10279.4.camel@dv> (sfid-20071125_014244_819504_30F6CFBB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-11-24 at 15:46 -0500, Vadim Peretokin wrote:
> Yes! Yes there was a new_id thing that we used echo on.
> 
> Here is the output of that command:
> 
> vadi@vadi-laptop:~$ lspci -n
[skip]
> 03:00.0 0200: 1799:701f (rev 20)

I've submitted a patch to add that ID to the driver.  Just for the
record, it's actually Belkin F5D7010 v7.  You lost "k" and "5" in the
subject, check your keyboard :)

-- 
Regards,
Pavel Roskin
