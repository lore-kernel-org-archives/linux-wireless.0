Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:29377 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbYKXSxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 13:53:15 -0500
Subject: Re: ath5k: can't browse at all.
From: Pavel Roskin <proski@gnu.org>
To: Irwan Siajadi <dev.bahamot@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <978525.69086.qm@web59613.mail.ac4.yahoo.com>
References: <978525.69086.qm@web59613.mail.ac4.yahoo.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 13:53:12 -0500
Message-Id: <1227552792.26229.6.camel@dv> (sfid-20081124_195326_027272_9C5673A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-11-24 at 09:41 -0800, Irwan Siajadi wrote:
> The AR2425 is able to obtain IP address from the router, 
> able to ping with good results, but can't browse at all.
> Below are the info on my setup, if you need more info please let me know.

That's unlikely to be a driver problem.  The driver doesn't distinguish
pings from other packets.  The only significant difference could be in
the packet size.  You can try ping with larger packets to check if
that's the problem.

I suggest that you use normal network troubleshooting procedures and not
assume the driver to be a problem unless you have a better evidence.
Check routing, check if the nameservers in /etc/resolv.conf are working.
I'm sure there are detailed guides how to troubleshoot networks.

-- 
Regards,
Pavel Roskin
