Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:13348 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966085Ab0BZUqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 15:46:54 -0500
Received: by qw-out-2122.google.com with SMTP id 8so103260qwh.37
        for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2010 12:46:53 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 26 Feb 2010 14:46:53 -0600
Message-ID: <a221c0101002261246x17729ad4s69fb24d654344416@mail.gmail.com>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal DMA
	errors
From: Nathan Schulte <reklipz@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 26 Feb 2010, Linus Torvalds wrote:
> > On Fri, 26 Feb 2010, Michael Buesch wrote:
> > I'd rather appreciate that somebody who owns such a device and can reproduce the bug
> > would do some _real_ debugging on the issue instead.
>
> I have the hardware, I can reproduce the bug 100% of the time.
>
> So send me a patch. I'll try it. But I have no hardware docs, nor any
> information about how that SSB bridge is supposed to work, or why DMA
> might be failing.
>
> 			Linus

I'm in the same boat as Linus.  Let me know what I can do to help.

-Nate
