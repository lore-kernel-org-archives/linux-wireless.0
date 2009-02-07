Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eta-ori.net ([91.121.142.51]:42528 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbZBGIPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 03:15:06 -0500
Received: from [IPv6:2001:6f8:10ae:0:217:31ff:fe81:8c8] (istari.kleinerfeigling.org [IPv6:2001:6f8:10ae:0:217:31ff:fe81:8c8])
	by orion.eta-ori.net (Postfix) with ESMTPSA id C887432413F
	for <linux-wireless@vger.kernel.org>; Sat,  7 Feb 2009 09:15:00 +0100 (CET)
Message-ID: <498D431A.9000608@impulze.org> (sfid-20090207_091513_128333_63BE1C1E)
Date: Sat, 07 Feb 2009 09:15:22 +0100
From: Daniel Mierswa <impulze@impulze.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: location of binaries and libraries of new wifi tools
References: <498CC07F.3080800@impulze.org> <1233981671.3652.6.camel@localhost>
In-Reply-To: <1233981671.3652.6.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07.02.2009 05:41, Dan Williams wrote:
> Stuff in /bin or /sbin can certainly link to stuff in /usr without
> breaking.  The only time it breaks is when you're using network
> mounted /usr and you need the wireless stack to boot the machine and
> mount /usr.  But then you have to ask yourself, why are you using a
> network mounted /usr over wifi?  That seems odd.  Somebody turns on a
> microwave or starts to use a cordless phone and you're hosed.
Right, point taken. But why should there be a non-working binary in
/sbin if you don't have /usr mounted. Couldn't we just stick all the
tools in /usr/{s,}bin then?


-- 
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply
know better than you do.
               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22
