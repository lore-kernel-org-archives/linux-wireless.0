Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35179 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaB0QNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:13:50 -0500
Message-ID: <1393517627.4648.4.camel@jlt4.sipsolutions.net> (sfid-20140227_171356_036259_BEB31769)
Subject: Re: pci-half-mini 7260 Wireless AC support 3.13
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Nelson <tim.l.nelson@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Feb 2014 17:13:47 +0100
In-Reply-To: <CAOAOC6agHr6mVB2jcUx1qHWnBJZyOw0=KP0Wp5BVhrvJgRhmQg@mail.gmail.com> (sfid-20140227_171024_068640_111A0D6A)
References: <CAOAOC6a96e5MrEOVY=KXirhUU-rJRv2hgz5B0so9SkWYMpoDfw@mail.gmail.com>
	 <1393517094.4648.3.camel@jlt4.sipsolutions.net>
	 <CAOAOC6agHr6mVB2jcUx1qHWnBJZyOw0=KP0Wp5BVhrvJgRhmQg@mail.gmail.com>
	 (sfid-20140227_171024_068640_111A0D6A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-27 at 11:10 -0500, Tim Nelson wrote:
> Although it is a similar setup, no.  I am able to connect on ALL
> radios but the AC radio's on the 3702's.  I encounter no bugs, no loss
> of connection.  However, I NEVER connect to the AC radio on the AP.  I
> know it works due to my Nexus 5 connecting to the AC radio
> immediately.  If the 3702 saw that my adapter was AC capable, it would
> use the AC radio and not the A/N.  Also, every other device with
> wireless AC connects fine without issue, even the same laptop on it's
> Windows 8 partition.

All of this doesn't make a lot of sense to me. What do you even mean by
"AC radio" in this context? Is there a separate SSID? BSSID? something
else?

> If it is AC capable, how do I get it to connect to the AC radio's on
> the AP?  It is entirely possible it is something Cisco/Linux related
> with how they communicate as well.

I don't see how the AP would be able to choose where the client
connects, without maybe some CCX stuff that Linux doesn't have.

johannes

