Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49585 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbYI3OWu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 10:22:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [RFC/T] b43: to few loop tries in do_dummy_tx
Date: Tue, 30 Sep 2008 16:22:25 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Peter Stuge <peter@stuge.se>
References: <48E11F1E.50705@lwfinger.net> <200809301528.26304.mb@bu3sch.de> <200809301611.19035.hs4233@mail.mn-solutions.de>
In-Reply-To: <200809301611.19035.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809301622.26024.mb@bu3sch.de> (sfid-20080930_162314_621098_B0CF9650)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 30 September 2008 16:11:18 Holger Schurig wrote:
> > The b43 and b43-legacy driver are _based_ on these
> > specifications. There are no other specs available.
> 
> Can it be the case that the binary windows driver the spec 

They didn't use a windows driver.

> producer analyzed used a different PCI settings?  And that 
> therefore the delays/access-patterns in the binary driver work 
> as expected *in their environment*, but that Linux might have 
> programmed the PCI bus/controller differently and that therefore 
> the identical approach fails (sometimes) ???

Unlikely.

-- 
Greetings Michael.
