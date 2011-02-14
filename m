Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:53881 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab1BNNEK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 08:04:10 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Poy64-0007g1-PC
	for linux-wireless@vger.kernel.org; Mon, 14 Feb 2011 14:04:08 +0100
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 14:04:08 +0100
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 14:04:08 +0100
To: linux-wireless@vger.kernel.org
From: jpo234 <pommnitz@yahoo.com>
Subject: Re: WPA for Ethernet?
Date: Mon, 14 Feb 2011 13:03:53 +0000 (UTC)
Message-ID: <loom.20110214T134440-308@post.gmane.org>
References: <loom.20110211T163104-102@post.gmane.org> <20110214121013.GA6431@jm.kir.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j <at> w1.fi> writes:

> Are you looking for a custom solution that would not work with anyone
> else or a standard solutions like MACsec that Henry already mentioned?

I'm not sure yet. I'm looking for any reasonable solution and obviously
an accepted standard would be a plus, but I would not completely rule out
a custom solution.

> You could obviously make the kernel do some custom hacks like trying to
> fit IEEE 802.11 encryption into other network types, but it would sound
> more reasonable to work on a standard solution..

My ideal solution would work for both, wired Ethernet and 802.11 (in
IBSS-mode btw.).

> CCMP is designed for IEEE 802.11 header and as such, it does not really
> work as-is with other network types. WPA-PSK 4-way handshake could be
> used to manage keys with some small changes, but this would be very much
> a custom solution.

Thanks for sharing your insights. They are much appreciated!

Initially I didn't provide much details because I thought that my questions
were too far off topic for the wireless list. Since it seems people are willing
to discuss it here, I'll provide a more detailed description of my problem:

I'm working on a wireless communication system for public safety organizations.
Normally it uses a wireless MANET with OLSR routing as backbone, but sometimes
the OLSR MANET gets extended over wired Ethernet links.
Up until now the communication is secured with IPsec. This works reasonably
well for unicast data, but gets a really big headache for Multicast (think
video from network cameras).

Now I'm looking for a sane security solution that would work over both, 802.11
and Ethernet and supports Multicast. I could probably get an insane IPsec
solution working, but it would feel less than satisfactory.

Regards
  Joerg

