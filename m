Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:63257 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbZKLSez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 13:34:55 -0500
Received: by fxm21 with SMTP id 21so2564138fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 10:34:58 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: Please share info about power consumption characteristics of your USB adapter
Date: Thu, 12 Nov 2009 19:34:15 +0100
Cc: linux-wireless@vger.kernel.org
References: <200911112219.08814.jkrzyszt@tis.icnet.pl> <200911121731.35069.jkrzyszt@tis.icnet.pl> <200911121811.34251.jkrzyszt@tis.icnet.pl>
In-Reply-To: <200911121811.34251.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Message-Id: <200911121934.15989.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 12 November 2009 18:11:32 Janusz Krzysztofik wrote:
> Thursday 12 November 2009 17:31:33 Janusz Krzysztofik napisał(a):
> > Wednesday 11 November 2009 22:52:16 Bartlomiej Zolnierkiewicz napisał(a):
> > > On Wednesday 11 November 2009 22:19:07 Janusz Krzysztofik wrote:
> > > > Pentagram P 6132-08
> > >
> > > 450mA so you can cross this one out from your list.
> >
> > Dzięki.
> >
> > Gdyby podał mi Pan więcej danych: pasujący sterownik, identyfikator USB, to
> > wpisałbym to do odpowiedniej tabelki, tak jak zrobiłem z danymi otrzymanymi
> > od innych.
> >
> > Janusz
> 
> Sorry, I didn't inted to send that message to the list. I asked for more data 
> (driver, USB ID) on Pentagram P 6132-08 to put it into the wiki.

USB IDs:

  idVendor           0x148f Ralink Technology, Corp.      
  idProduct          0x3070                               

and the driver is rt2800usb (or alternatively staging/rt2870sta).

Pozdrawiam.
-- 
Bartlomiej Zolnierkiewicz
