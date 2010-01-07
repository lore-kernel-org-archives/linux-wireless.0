Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330Ab0AGGZo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 01:25:44 -0500
Subject: Re: [PATCH] libertas: Remove carrier signaling from the scan code
From: Dan Williams <dcbw@redhat.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Holger Schurig <holgerschurig@gmail.com>
In-Reply-To: <1261964494.16627.92.camel@localhost.localdomain>
References: <20091218103649.GA3568@sortiz.org>
	 <1261212074.23392.10.camel@localhost.localdomain>
	 <1261964494.16627.92.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 06 Jan 2010 22:25:25 -0800
Message-Id: <1262845525.3608.71.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-12-27 at 17:41 -0800, Marcel Holtmann wrote:
> Hi John,
> 
> > > There is no reason to signal a carrier off when doing a 802.11 scan.
> > > 
> > > Cc: Dan Williams <dcbw@redhat.com>
> > > Cc: Holger Schurig <holgerschurig@gmail.com>
> > > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> > 
> > Acked-by: Dan Williams <dcbw@redhat.com>
> 
> can we get this driver merged since no wireless driver should play with
> carrier on/off settings during scanning.
> 
> I would actually go that far that we should fix it in 2.6.33 and also
> backport it to -stable.

Well likewise even if it *did* play with carrier, nothing should be
listening to the carrier signal for wifi devices anyway.  So it
shouldn't really be a problem.

Dan


