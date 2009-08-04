Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54220 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933130AbZHDV6R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 17:58:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: gregor kowski <gregor.kowski@gmail.com>
Subject: Re: [RESEND] [PATCHv2] b43 add harware tkip
Date: Tue, 4 Aug 2009 23:58:15 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <83a869cd0907271349h248204at74cc1603419fc83b@mail.gmail.com> <200907312308.31066.mb@bu3sch.de> <83a869cd0908041454i474b0ee4hfb770c7c5166be7f@mail.gmail.com>
In-Reply-To: <83a869cd0908041454i474b0ee4hfb770c7c5166be7f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908042358.15966.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 August 2009 23:54:42 gregor kowski wrote:
> On 7/31/09, Michael Buesch <mb@bu3sch.de> wrote:
> > On Friday 31 July 2009 23:04:17 gregor kowski wrote:
> >> Hi Michael,
> >>
> >> > It's mapped to 4, because you removed the old API support.
> >> > (I'm not sure whether we want to remove that support, yet. Gimme some
> >> > time
> >> > on it...)
> >> >
> >> Does the old API still useful ?
> >
> > Well, I'm not sure. Why do we remove it at all? It just avoids one single
> > if condition in your tkip patch, doesn't it?
> >
> because you ask it : "We should probably remove that new_kidx_api crap
> alltogether." [1] :)

<quote> probably </quote>

> There is really bugs in the current code.

You always talk about "bugs". What are these "bugs"? Is it just the wrong
max_nr_keys assignment? That's trivial to fix.


-- 
Greetings, Michael.
