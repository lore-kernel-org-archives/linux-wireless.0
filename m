Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:28354 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbYFPGe1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 02:34:27 -0400
Message-ID: <20080616023427.gm71g7actwc8scsg-cebfxv@webmail.spamcop.net> (sfid-20080616_093322_804968_D2F63F3C)
Date: Mon, 16 Jun 2008 02:34:27 -0400
From: Pavel Roskin <proski@gnu.org>
To: Mark Roberts <mroberts1839@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Problem with master mode on BCM4318
References: <eaf2efa20806152024i510ea7auc9aba61b68598ec0@mail.gmail.com>
	<1213587639.2469.10.camel@dv>
	<eaf2efa20806152309o342d0a0cs31e73dff3ba3d947@mail.gmail.com>
In-Reply-To: <eaf2efa20806152309o342d0a0cs31e73dff3ba3d947@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Mark Roberts <mroberts1839@gmail.com>:

> I am running 2.6.24-18-generic, so I have followed this procedure, as
> described at http://www.linuxwireless.org/en/users/Drivers/b43 :

compat-wireless is a backport of the current drivers, so you should be  
using the firmware for Linux 2.6.25 and newer.

I cannot get to www.linuxwireless.org at all at the moment, so I  
cannot check if the instruction is indeed unclear about it.

As fast as I know, the master mode support in mac80211 has not been  
merged yet into the wireless-testing branch, so I don't think it's  
present in compat-wireless.  There are some unofficial patches for  
that, but you never mentioned them.  Did any document promised you  
master mode support if you use compat-wireless?

-- 
Regards,
Pavel Roskin
