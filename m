Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:35633 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbZEPJcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 05:32:23 -0400
Received: by ewy24 with SMTP id 24so3000064ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2009 02:32:24 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: rt73usb Access point status
Date: Sat, 16 May 2009 11:32:21 +0200
Cc: linux-wireless@vger.kernel.org,
	Alexandre Becholey <alexandre@shockfish.com>
References: <557754.25367.qm@web51403.mail.re2.yahoo.com> <20090512215817.bd1c6895.cjsthompson@gmail.com> <wf4ovlo25e.fsf@calligramme.charmers>
In-Reply-To: <wf4ovlo25e.fsf@calligramme.charmers>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200905161132.21437.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 16 May 2009, Jon Fairbairn wrote:
> "Christoph .J Thompson" <cjsthompson@gmail.com> writes:
> 
> > On Tue, 12 May 2009 09:16:12 +0100
> > Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk> wrote:
> >> Is there any prospec of persuading Ralink either to release
> >> a mended version of the firmware or to free the old version?
> >
> > I think Ivo van Doorn said he didn't want to bother RaLink with that. I was
> > thinking about writing to them about it but that's difficult because I don't
> > really understand the technical specifics of the issue.
> 
> Me neither; in particular, does it work as an AP in Windows?
> If so, how does it get round the bug in the driver?

Simply by indicating that every single frame passed to the driver has
been send out succesfully and thus completely ignoring the real status.

I am awaiting a patch from Alexandre which will add that same behavior
to rt2x00.

Ivo
