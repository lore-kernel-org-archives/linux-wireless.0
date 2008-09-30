Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49224 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYI3OVy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 10:21:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Peter Stuge <peter@stuge.se>
Subject: Re: [RFC/T] b43: to few loop tries in do_dummy_tx
Date: Tue, 30 Sep 2008 16:21:30 +0200
Cc: bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>
References: <48E11F1E.50705@lwfinger.net> <200809301528.26304.mb@bu3sch.de> <20080930141353.16996.qmail@stuge.se>
In-Reply-To: <20080930141353.16996.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809301621.30913.mb@bu3sch.de> (sfid-20080930_162157_832288_202D9B3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 30 September 2008 16:13:53 Peter Stuge wrote:
> At this point, if there are only/mostly benefits, I don't see why
> deviating from the specs is bad - after all they "only" document
> another driver, right?

The past taught us that deviations from the specs are almost certainly
hidden bugs somewhere else. We had that dozens of times.
In this case, however, I think it's not the case.

-- 
Greetings Michael.
