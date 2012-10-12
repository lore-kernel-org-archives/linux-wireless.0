Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40234 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JLOpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 10:45:54 -0400
Date: Fri, 12 Oct 2012 10:33:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
Message-ID: <20121012143355.GA25235@tuxdriver.com> (sfid-20121012_164558_009423_AEF12E23)
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
 <20121011203112.GB3317@kroah.com>
 <87haq017wi.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87haq017wi.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 12, 2012 at 10:11:57AM +0300, Kalle Valo wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
> > Very nice.
> 
> Indeed.
> 
> > But what is keeping this driver from going to the "proper" place in the
> > kernel tree (i.e. drivers/net/...)?  I don't have a problem adding it to
> > the staging tree, but it would need a TODO file to list what is needed
> > to get it out of the staging tree.
> 
> I did a really quick 5 min review of this driver and IMHO this should go
> directly to drivers/net/wireless/ (or maybe to drivers/net/wireless/ath,
> Luis?), I don't see any reason why this should go to staging. The code
> looks clean and is only 2 kLOC. But I'll review this better during the
> weekend and also run some build tests.

I have no particular objection to that.  FWIW, Pontus contacted me
and said something like "I've got this driver that sucks and needs
a lot of work, should it go to staging?"  Perhaps he was being too
hard on himself? :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
