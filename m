Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:43105 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933429AbZHWDAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 23:00:38 -0400
Received: by pxi34 with SMTP id 34so4637306pxi.4
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2009 20:00:39 -0700 (PDT)
Message-ID: <4A90B086.1020503@lwfinger.net>
Date: Sat, 22 Aug 2009 21:59:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: feng tian <feng.of.tian@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Abour linux driver supports BCM4325
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com>	 <4A8E8F59.9050706@lwfinger.net>	 <1250858409.5137.2.camel@johannes.local>	 <f42a38140908212242h1ce0339fw1243dbacf54000ab@mail.gmail.com>	 <4A90005B.3030101@lwfinger.net>	 <1250964823.23605.22.camel@johannes.local> <f42a38140908221927qabc3f25t60f348f7c4a446c9@mail.gmail.com>
In-Reply-To: <f42a38140908221927qabc3f25t60f348f7c4a446c9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

feng tian wrote:
> Thank you for the information.
> I get your point. As for the radio and phy driver, I think it's  some
> command based configurations for the chip via SDIO. And that I can
> refer to the BCM 43xx PCI driver codes.
> Wonder if it's feasible. Needs your comments.
> Thanks

The first step is to be able to read/write the various registers via
SDIO. That will be similar to the PCI operations. The next step is
knowing what to read/write and when. We are still working that out for
PCI. It is not trivial. See the recent postings of patches for the LP
pHY in the linux-wireless mailing list. These are _NOT_ complete.
