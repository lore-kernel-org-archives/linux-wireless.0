Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39770 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab1FJNq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 09:46:29 -0400
Date: Fri, 10 Jun 2011 09:40:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: Arend van Spriel <arend@broadcom.com>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] drivers: bcma: export bcma_core_disable() function
Message-ID: <20110610134016.GC2665@tuxdriver.com> (sfid-20110610_154633_375467_53917D45)
References: <1307642840-3043-1-git-send-email-arend@broadcom.com>
 <BANLkTim4p+jjm3iT63Lum146K38iGgvhWw@mail.gmail.com>
 <4DF2042C.6060605@broadcom.com>
 <20110610133911.36f9f8b2@Nokia-N900>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20110610133911.36f9f8b2@Nokia-N900>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 10, 2011 at 01:39:11PM +0000, Michael Büsch wrote:
> On Fri, 10 Jun 2011 13:46:52 +0200
> "Arend van Spriel" <arend@broadcom.com> wrote:
> > > Michael said we should not do do such a exporting without getting
> > > users within the same patch serie.
> > That is going to be hard for me despite my willingness to comply. Our 
> > driver is still in staging so we submit our brcm80211 patches to Greg 
> > KH. I figured it would be better to do submit patches for bcma on 
> > wireless repository.
> 
> There are no rules without exceptions ;-)

Right, so I don't really mind taking it.  OTOH, maybe Greg could just
carry the patch in his staging tree...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
