Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:40316 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0FTFlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jun 2010 01:41:08 -0400
Received: by fg-out-1718.google.com with SMTP id d23so766963fga.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jun 2010 22:41:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100618184257.GB6282@tuxdriver.com>
References: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
	<20100618184257.GB6282@tuxdriver.com>
Date: Sun, 20 Jun 2010 08:41:06 +0300
Message-ID: <AANLkTimN8oZ63m7cp2lE5MuFiEJ8iAGKswKIENTjIhMg@mail.gmail.com>
Subject: Re: [RFC] wireless-regdb: Add A band in IL
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach
egrumbach@gmail.com


On Fri, Jun 18, 2010 at 21:42, John W. Linville <linville@tuxdriver.com> wrote:
>
> On Wed, May 26, 2010 at 09:49:29AM +0300, Emmanuel Grumbach wrote:
> > A band in allowed in IL, according to official document issued by the Ministry
> > of Communications: http://www.moc.gov.il/sip_storage/FILES/1/1061.pdf.
> >
> > 5150 - 5250 200mW e.i.r.p. OUTDOOR forbidden
> > 5250 - 5350 200mW e.i.r.p. OUTDOOR forbidden DFS mandatory
> >
> > 40Mhz is allowed in A band for every WiFi-Alliance certified equipment.
> >
> > ***************************************************************
> > Not to be merged for the moment
> > ***************************************************************
> >
> > CC: Michael Green <Michael.Green@atheros.com>
> > CC: David Quan <David.Quan@atheros.com>
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > ---
> >  db.txt |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/db.txt b/db.txt
> > index e63a43e..d49c397 100644
> > --- a/db.txt
> > +++ b/db.txt
> > @@ -319,6 +319,8 @@ country IE:
> >
> >  country IL:
> >       (2402 - 2482 @ 40), (N/A, 20)
> > +     (5150 - 5250 @ 40). (N/A, 200 mW), NO-OUTDOOR
> > +     (5250 - 5350 @ 40). (N/A, 200 mW), NO-OUTDOOR, DFS
> >
> >  country IN:
> >       (2402 - 2482 @ 40), (N/A, 20)
>
> Is this issue now settled?

Yes, I think that Michael Green agreed for this patch. Once he will
reply to make sure, we will be able to move on to a real patch.
