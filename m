Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.193.33.39] ([78.193.33.39]:52034 "EHLO qult.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab3EPXtG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 19:49:06 -0400
Date: Fri, 17 May 2013 01:48:57 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k_htc: Target is unresponsive
Message-ID: <20130516234857.GA17867@zenon.in.qult.net> (sfid-20130517_014911_765584_6954AFC2)
References: <20130515134258.GA9033@zenon.in.qult.net>
 <5194DEB3.2060407@rempel-privat.de>
 <20130516172030.GD21850@zenon.in.qult.net>
 <51951B90.70909@rempel-privat.de>
 <20130516185030.GB16833@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130516185030.GB16833@zenon.in.qult.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 16, 2013 at 08:50:30PM +0200, thus spake Ignacy Gawedzki:
> I'll try on yet another one and will tell you the results.

Just tried on ICH7, same thing.  The easiest way to reproduce the bug is to
boot into single user mode ("recovery mode" on Ubuntu), in order to prevent
any NetworkManager or udev from interfering.  Then, without any attempt to up
the interface, reboot the system by typing "reboot" in a root shell.

-- 
 "The whole problem with the world is that fools and fanatics are
   always so certain of themselves, and wiser people so full of doubts."
                                                 - Bertrand Russell
