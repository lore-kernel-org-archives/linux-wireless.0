Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37467 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965639Ab2JZSHZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 14:07:25 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1182217eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2012 11:07:23 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] carl9170: fix spurious transmissions in sniffer mode
Date: Fri, 26 Oct 2012 20:07:16 +0200
Cc: linville@tuxdriver.com
References: <201209112318.35334.chunkeey@googlemail.com> <201210131059.53325.chunkeey@googlemail.com>
In-Reply-To: <201210131059.53325.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210262007.17369.chunkeey@googlemail.com> (sfid-20121026_200731_252390_07A9F2D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 13 October 2012 10:59:53 Christian Lamparter wrote:
> On Tuesday 11 September 2012 23:18:34 Christian Lamparter wrote:
> > Several people have complained about an unusual
> > and undocumented feature of the AR9170 hardware:
> > 
> > In siffer mode, the hardware generates spurious
> > ACK frames for every received frame... even
> > broadcasts.
> > 
> > The reason for this malfunction is unknown:
> > <http://marc.info/?l=linux-wireless&m=134517238506033>
> > But there's a workaround: Instead of the special
> > sniffer mode, the hardware will be put into
> > station mode and all rx filters are disabled.
> > 
> > Reported-by: Johannes Berg <johannes@sipsolutions.net>
> > Reported-by: Marco Fonseca <marco@tampabay.rr.com>
> > Reported-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>
> > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > ---
> John,
> 
> Do you have doubts about this patch, or is there a problem 
> that I don't know about?

John,

can you comment? Or do you need a resend? Or should I stop
asking about it ;)?

Regards,
	Chr
