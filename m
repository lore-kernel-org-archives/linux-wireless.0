Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:36450 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754325Ab0KTQte (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 11:49:34 -0500
Message-ID: <4CE7FC1A.3070709@gmx.net>
Date: Sat, 20 Nov 2010 17:49:30 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Linux Client vs. CISCO AP with band select
References: <4CE6EA98.3020300@gmx.net> <20101120112753.GA12225@jm.kir.nu> <201011201304.48821.helmut.schaa@googlemail.com>
In-Reply-To: <201011201304.48821.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-20 13:04, Helmut Schaa wrote:
> If the Cisco APs would reply to direct probes we could (as a workaround) just
> send an additional direct probe here. I agree with Jouni that the AP behavior
> is just stupid but the users will blame Linux for not being able to connect
> and not the AP vendor.

Suddenly the term "<whatever working protocol> fixup" comes to mind reading
your and Jounis answers;-) I agree with you, too. But I'm not the one
administrating the APs here at the university. Maybe I can convince my
college, but as long as you want to find a solution for Linux as long I'll
try to give you remote hands;-)

We tried to deactivate "band select" already and my laptop was able to
connect instantly to the nearest 2.4GHz AP. But that's the point where the
second "feature" kicks in. "load balancing" is then used by the APs to kick
stations trying to push them to an other AP. At this point Linux clients
have troubles again to get a stable connection.

> Wolfgang, could you please try the (untested) patch below if it makes any
> difference?

Sure, I'll try as soon as I'm back at the office on Monday. And I'll try to
get the logs and packet traces for Jouni, too.

Greetings,
Wolfgang
-- 
Wolfgang Breyha <wbreyha@gmx.net> | http://www.blafasel.at/
Vienna University Computer Center | Austria
