Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jazz.viagenie.ca ([206.123.31.2]:39497 "EHLO jazz.viagenie.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618AbZKYNt5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 08:49:57 -0500
Message-ID: <4B0D360A.3080801@viagenie.ca>
Date: Wed, 25 Nov 2009 08:50:02 -0500
From: Simon Perreault <simon.perreault@viagenie.ca>
MIME-Version: 1.0
To: Pat Erley <pat-lkml@erley.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: Hardware for 802.11s
References: <4B0C5E6F.5040302@viagenie.ca> <4B0C6493.7010805@erley.org>
In-Reply-To: <4B0C6493.7010805@erley.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your reply.

Pat Erley wrote, on 2009-11-24 17:56:
> I don't have time tonight, but I believe you can make b43 work by triggering a 
> scan after bringing the interface up.  I know I've made b43 work in the past.

What do you mean, "triggering a scan"? What command line does that translate into?

I've tried all variations of "iw ... scan ..." I could think of and eventually I
got this:

root@OpenWrt-2:~# iw dev mesh0 station dump
Station 00:21:29:8a:e6:01 (on mesh0)
	inactive time:	811216 ms
	rx bytes:	546
	rx packets:	13
	tx bytes:	334
	tx packets:	5
	signal:  	-6 dBm
	tx bitrate:	1.0 MBit/s
	mesh llid:	0
	mesh plid:	0
	mesh plink:	LISTEN

Yay, a blip!!!

But the other WRT54GL still shows nothing, and of course I still can't ping.

Thanks,
Simon
-- 
DNS64 open-source   --> http://ecdysis.viagenie.ca
STUN/TURN server    --> http://numb.viagenie.ca
vCard 4.0           --> http://www.vcarddav.org
