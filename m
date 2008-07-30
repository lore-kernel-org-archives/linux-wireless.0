Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39270 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbYG3EbI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 00:31:08 -0400
Message-ID: <20080730003106.k0irmx7u8swk4cgk-cebfxv@webmail.spamcop.net> (sfid-20080730_063110_788117_4446A5AE)
Date: Wed, 30 Jul 2008 00:31:06 -0400
From: Pavel Roskin <proski@gnu.org>
To: rschneiderman@yahoo.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: broadcom 4306 rev. 3 uses b43 instead of b43legacy
References: <346184.16399.qm@web52404.mail.re2.yahoo.com>
In-Reply-To: <346184.16399.qm@web52404.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Richard Schneiderman <rschneiderman@yahoo.com>:

> Is this known bug? I can see my wireless network using wlist wlan0 scan.

It's not a bug.  It's meant to be this way.

> How do I make it use the b43legacy instead of b43. I'm using   
> opensuse 11 and have compiled the latest code and it is still not   
> working.

It should work with b43.  If it doesn't work for you, please report it  
as a bug.

-- 
Regards,
Pavel Roskin
