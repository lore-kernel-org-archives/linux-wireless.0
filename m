Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933496AbXFFReP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2007 13:34:15 -0400
Subject: Re: Marvell CB35 cardbus cards
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200706061627.01839.hs4233@mail.mn-solutions.de>
References: <1181061336.8274.36.camel@johannes.berg>
	 <200706061352.43421.hs4233@mail.mn-solutions.de>
	 <1181138216.20573.1.camel@xo-28-0B-88.localdomain>
	 <200706061627.01839.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 13:38:36 -0400
Message-Id: <1181151516.30586.2.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-06-06 at 16:27 +0200, Holger Schurig wrote:
> > What part is in the CB35?  Is that an 8335?
> 
> Maybe. The driver is for a PCI device and the whole driver is 
> very different to, say, the 8388 in the libertas-driver.

Yes, that's what I've just heard.  It apparently is an 8335 device,
which is a lot more softmac than the 8388.  So it would likely have to
be a different driver, ideally based on mac80211.

Dan


