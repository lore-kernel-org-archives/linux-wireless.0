Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38440 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbXGYPPf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 11:15:35 -0400
Message-ID: <46A76915.3040902@garzik.org>
Date: Wed, 25 Jul 2007 11:15:33 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: Please pull patch-bomb for iwlwifi
References: <20070725085754.GA670@mail.intel.com> <46A75CD9.9050100@garzik.org> <200707251643.14926.hs4233@mail.mn-solutions.de>
In-Reply-To: <200707251643.14926.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig wrote:
> So, if you ask them to post each and every patch on 
> linux-wireless, then other projects should do the same. Some 
> projects (e.g. bcm43xx) mostly do cross-post. Is this the way 
> people should go?


Yes, definitely.

* It is unscalable for core wireless developers to scan every individual 
driver mailing list.

* The amount of review is demonstrably lower when you bypass the core 
mailing list.

* The amount of information sharing, with regards to common problems and 
common solutions, is far far lower when people and knowledge are spread 
out across a wide variety of mailing lists.

* It's a huge pain to scan $N mailing list archives for something, when 
you could just scan one and be reasonably certain that your search 
covered all useful areas.

Like open source itself, we want to bring people -together- to work on a 
common vision.  Not have $N competing visions, that are only reconciled 
when patches are pushed upstream to linville.  That puts additional 
burden on linville, and lowers the quality of the code (as described in 
more detail in my response to James K just now).

	Jeff


