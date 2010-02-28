Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43635 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032157Ab0B1WXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 17:23:08 -0500
Received: by bwz1 with SMTP id 1so4118bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2010 14:23:06 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [ipw3945-devel] iwl4965: 11a channels disabled in current wireless-testing
Date: Sun, 28 Feb 2010 23:23:02 +0100
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
References: <201002281534.11656.helmut.schaa@googlemail.com> <b170af451002281401p5ab18a97lab32a26a1fd27737@mail.gmail.com> <b170af451002281402w2ffd2f29t70e4dedf216b21fc@mail.gmail.com>
In-Reply-To: <b170af451002281402w2ffd2f29t70e4dedf216b21fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201002282323.02489.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Sonntag 28 Februar 2010 schrieb Rafał Miłecki:
> W dniu 28 lutego 2010 23:01 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> > 2010/2/28 Helmut Schaa <helmut.schaa@googlemail.com>:
> >> have there been any recent changes to the regulatory stuff, especially
> >> in conjunction with iwlagn?
> >>
> >> Because with wireless-testing I get all 11a channels disabled by default
> >> and the same for channels 12 & 13 in the g-band.
> >
> > Please google for regulatory and regions. Higher frequencies
> > (channels) are not allowed in some countries.
> 
> Blah, you wrote about regulatory changes... Ignore my response.

Yeah, maybe I wasn't precise enough. I always had quite a number of 11a
channels enabled with my iwl4965 (AFAIK depending on the channel mask encoded
in the cards EEPROM) but that changed some time ago. I don't know when because
I didn't have a need to connect to 11a APs for quite some time. Hence my
question.

Helmut
