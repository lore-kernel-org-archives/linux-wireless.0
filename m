Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36752 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbaETKVO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 06:21:14 -0400
Message-ID: <1400581259.4474.3.camel@jlt4.sipsolutions.net> (sfid-20140520_122117_133272_BE4EBEA9)
Subject: Re: if i deselect PCIEPORTBUS, why are iwlwifi PCIE modules still
 being compiled?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 20 May 2014 12:20:59 +0200
In-Reply-To: <alpine.LFD.2.11.1405200526530.12158@localhost>
References: <alpine.LFD.2.11.1405200342050.10462@localhost>
	  (sfid-20140520_101149_157876_1874D563) <1400574452.4474.2.camel@jlt4.sipsolutions.net>
	 <alpine.LFD.2.11.1405200526530.12158@localhost>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-20 at 05:28 -0400, Robert P. J. Day wrote:

> > The whole driver depends on CONFIG_PCI, maybe it should depend on
> > something more PCIe specific, but that wasn't easy to sort out, and
> > the APIs it needs aren't PCIe specific afaict.
> 
>   ok, i'll have to think about that for a few minutes. am i at least
> correct in my understanding that, technically, the kernel config
> option PCIEPORTBUS is supposed to control whether one wants basic PCIE
> support or not?

I don't know, sorry.

johannes


