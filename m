Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63040 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbXKXTdM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 14:33:12 -0500
Message-ID: <20071124143310.a7pta1f4lc0k4ok0@webmail.spamcop.net> (sfid-20071124_193432_665601_5A8F0184)
Date: Sat, 24 Nov 2007 14:33:10 -0500
From: Pavel Roskin <proski@gnu.org>
To: Vadim Peretokin <vperetokin@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Belin FD7010 v7
References: <6995ca080711221239t2947765ds765fd933fce5de31@mail.gmail.com>
	<1195781993.11966.27.camel@dv>
	<6995ca080711221804w7310134aw8a5902e45aa09942@mail.gmail.com>
	<1195784707.11966.38.camel@dv>
	<6995ca080711230736n54330d30s96831a664d46df1c@mail.gmail.com>
	<1195879405.7449.62.camel@dv>
	<6995ca080711241054s4aeca1f9r2496a36f93a9db43@mail.gmail.com>
In-Reply-To: <6995ca080711241054s4aeca1f9r2496a36f93a9db43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Vadim Peretokin <vperetokin@gmail.com>:

> Yes, so I believe the problem was that that the rtl8180 driver didn't
> see, and claim the card. I believe the command I used to get the
> driver to see the card was "sudo echo -n <some adress here>" - I don't
> remember it exactly, but if you need it, I can dig it up.

I guess it was adding the PCI ID of the card to the driver using the  
"new_id" mechanism.  Yes, that would be useful.  The ID could be added  
to the driver, so that you would never need to do it again.

Please send the output of "lspci -n"

-- 
Regards,
Pavel Roskin
