Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49749 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbZIAM4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 08:56:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4)
Date: Tue, 1 Sep 2009 14:56:50 +0200
Cc: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A9BFCCB.6040808@ufra.edu.br> <200908312127.57610.mb@bu3sch.de> <3ace41890908311235i62ab0510neb8b2021c3f2945e@mail.gmail.com>
In-Reply-To: <3ace41890908311235i62ab0510neb8b2021c3f2945e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909011456.51711.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 31 August 2009 21:35:31 Hin-Tak Leung wrote:
> On Mon, Aug 31, 2009 at 8:27 PM, Michael Buesch<mb@bu3sch.de> wrote:
> > On Monday 31 August 2009 20:26:22 Hin-Tak Leung wrote:
> >> It would appear that the rw driver's ieee80211->mac80211 conversion
> >> has broken big- endian platforms, at a first guess.
> >
> > Last time I tested the device worked fine on my powerbook with zd1211rw/mac80211.
> > But that's maybe two or three release cycles in the past.
> >
> > --
> > Greetings, Michael.
> >
> 
> The rw ieee80211->mac80211 conversion happens in 2.6.27->26.28 ...
> Iguess the question is whether it was 2.6.28 or 2.6.27 you had success
> with? That's unfortunately two *and* three cycles in the past,
> respectively :-).
> 
> 

I certainly used zd1211rw/mac80211 and it worked.

-- 
Greetings, Michael.
