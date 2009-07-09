Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:37521 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbZGIFaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 01:30:09 -0400
Received: by bwz25 with SMTP id 25so3286285bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jul 2009 22:30:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f76a32050907061320n18f3c4c9j4d5589c9c9e45c02@mail.gmail.com>
References: <f76a32050907061006k3bed082fg3428a50370b0889b@mail.gmail.com>
	 <1246900337.20908.15.camel@johannes.local>
	 <f76a32050907061320n18f3c4c9j4d5589c9c9e45c02@mail.gmail.com>
Date: Thu, 9 Jul 2009 07:30:07 +0200
Message-ID: <f76a32050907082230r7b98c438ybf08d1a421717ad6@mail.gmail.com>
Subject: Re: rt73 in AP mode: PS frames buffered but missing TIM bit?
From: Stefan Steuerwald <salsasepp@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Sounds like a driver problem, it must not be reacting to set_tim()
> > properly.
> >
> > johannes
>
> Looking at rt73usb.c:2242, there isn't any initializer for .set_tim .
> Plausible explanation.
> It may be totally beyond me to just implement it. Let me find someone
> to ask nicely ;-) ...

I have an experimental patch working (sent for review to the rt2x00
mailing list).
I will report back here.

Stefan.
