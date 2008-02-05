Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from onyx.spiritone.com ([216.99.193.114]:51464 "EHLO
	onyx.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYBEVHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 16:07:15 -0500
To: Dan Williams <dcbw@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
        <1201264166.12870.16.camel@johannes.berg>
        <alpine.LFD.1.00.0801250753240.14161@hp.linux-foundation.org>
        <200801251723.58891.mb@bu3sch.de>
        <alpine.LFD.1.00.0801250841080.14161@hp.linux-foundation.org>
        <1201282027.3422.15.camel@localhost.localdomain>
        <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org>
        <1201282972.3422.19.camel@localhost.localdomain>
From: seniorr@aracnet.com (Russell S. Senior)
Date: 05 Feb 2008 12:55:00 -0800
Message-ID: <s4mr6fr86or.fsf@onyx.spiritone.com> (sfid-20080205_210720_707447_58306DDF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>>> "Dan" == Dan Williams <dcbw@redhat.com> writes:

Linus> Is it even physically *possible* to use that Intel wireless
Linus> chipset with anything but x86 CPU's (not just that, but
Linus> actually _Intel_ x86 CPU's)?  And would it make any sense
Linus> what-so-ever even if it was?

Dan> Yeah, 3945 and 4965 cards are mini PCI-E these days.  And there
Dan> are ipw2100, ipw2200, and ipw2915 mini PCI cards that you could
Dan> stick in embedded systems and such.  Though of course everyone
Dan> doing embedded stuff uses either Atheros or PrismII still,
Dan> certainly not ipw/iwl.

Fwiw, I would if I could.  I've got a couple mini-PCI Intel radios
sitting here that I would like to be able to use in various single
board computers (e.g. soekris and netgear wgt634u).  Right now, I am
mostly constrained to using Atheros radios, which is a situation I'd
rather not be in and have been looking forward to growing out of.


-- 
Russell Senior         ``I have nine fingers; you have ten.''
seniorr@aracnet.com
