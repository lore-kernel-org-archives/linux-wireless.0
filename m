Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55235 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbYI3N0g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 09:26:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC/T] b43: to few loop tries in do_dummy_tx
Date: Tue, 30 Sep 2008 15:26:11 +0200
Cc: Peter Stuge <peter@stuge.se>,
	wireless <linux-wireless@vger.kernel.org>
References: <48E11F1E.50705@lwfinger.net> <200809292038.37939.mb@bu3sch.de> <20080929211620.6344.qmail@stuge.se>
In-Reply-To: <20080929211620.6344.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809301526.11519.mb@bu3sch.de> (sfid-20080930_152642_551009_54840135)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 September 2008 23:16:20 Peter Stuge wrote:
> Michael Buesch wrote:
> > Actually, I do know since the very first days of bcm43xx that the
> > loop counts are not big enough in some of these loops.
> 
> Would it make sense to double check the conditions after the loop?

No it wouldn't. Accessing the registers has side-effects.

> > But I didn't change it, as it was said the current counts match the
> > specs.
> 
> Which specs?

Our specs?

-- 
Greetings Michael.
