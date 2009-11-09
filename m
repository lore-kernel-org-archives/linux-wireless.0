Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36189 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbZKIOPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 09:15:14 -0500
Date: Mon, 9 Nov 2009 09:14:59 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Holger Schurig <holgerschurig@googlemail.com>,
	Jan Kiszka <jan.kiszka@web.de>, linux-wireless@vger.kernel.org
Subject: Re: ar9170 in AP mode
Message-ID: <20091109141458.GA2805@tuxdriver.com>
References: <4AF6C7CD.7060108@web.de> <878wehf85v.fsf@purkki.valot.fi> <4AF6CC02.8080204@web.de> <m3639k9kq4.wl%holgerschurig@gmail.com> <87ocncdrfz.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ocncdrfz.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 09, 2009 at 10:37:36AM +0200, Kalle Valo wrote:
> Holger Schurig <holgerschurig@googlemail.com> writes:

> > So, I personally prefer to have "Do an AP right" or "Don't do it at
> > all". But please no general enablement.
> >
> > But, for example, having some CONFIG_AR9K_AP_MODE depending on
> > CONFIG_EXPERIMENTAL and a bit fat warning would do for me. Hopefully
> > this would scara away distros, so that they don't turn this on for
> > there standard kernel :-)
> 
> I think EXPERIMENTAL is not enough, I would prefer that the user needs
> to patch the driver to enable it. Or if that's not good enough, then
> maybe depend on BROKEN.

Here we go again... :-)

So I definitely agree that it should be off by default.  I also agree
that it should be difficult to turn it on accidentally.  We don't
need any extra wierd bug reports.

OTOH, I think we can all acknowledge that many people have reasonable
use cases with their fleet of equipment.  I wonder if a sysctl would
be enough of a deterrent?  They are fairly simple to turn-on, but
you do have to know about them to do so...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
