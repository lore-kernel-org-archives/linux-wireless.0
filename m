Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:50038 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbYI3OL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 10:11:29 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC/T] b43: to few loop tries in do_dummy_tx
Date: Tue, 30 Sep 2008 16:11:18 +0200
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	Peter Stuge <peter@stuge.se>
References: <48E11F1E.50705@lwfinger.net> <20080930055034.16412.qmail@stuge.se> <200809301528.26304.mb@bu3sch.de>
In-Reply-To: <200809301528.26304.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809301611.19035.hs4233@mail.mn-solutions.de> (sfid-20080930_161206_593129_B7EABF4C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The b43 and b43-legacy driver are _based_ on these
> specifications. There are no other specs available.

Can it be the case that the binary windows driver the spec 
producer analyzed used a different PCI settings?  And that 
therefore the delays/access-patterns in the binary driver work 
as expected *in their environment*, but that Linux might have 
programmed the PCI bus/controller differently and that therefore 
the identical approach fails (sometimes) ???
