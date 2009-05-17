Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56910 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZEQMvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 08:51:14 -0400
Received: by ewy24 with SMTP id 24so3478734ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 05:51:14 -0700 (PDT)
Date: Sun, 17 May 2009 14:51:10 +0200
From: "Christoph .J Thompson" <cjsthompson@gmail.com>
To: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt73usb Access point status
Message-Id: <20090517145110.87b68ff2.cjsthompson@gmail.com>
In-Reply-To: <wfzldcm7zr.fsf@calligramme.charmers>
References: <557754.25367.qm@web51403.mail.re2.yahoo.com>
	<20090512215817.bd1c6895.cjsthompson@gmail.com>
	<wf4ovlo25e.fsf@calligramme.charmers>
	<200905161132.21437.IvDoorn@gmail.com>
	<wfzldcm7zr.fsf@calligramme.charmers>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 17 May 2009 09:47:04 +0100
Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk> wrote:
> Ugh. But Microsoft make the de-facto standards after all :-(
> -- for a view that's illuminating, if depressing and
> annoying to those of us who think there's a point to
> compatibility, watch the talk Butler Lampson gave for Roger
> Needham's 50+5 presentation
> <http://research.microsoft.com/en-us/um/cambridge/events/needhambook/videos/1032/head.wmv>
> (list of talks is at
> <http://research.microsoft.com/en-us/um/cambridge/events/needhambook/videos/default.htm>)

Haven't used Windows seriously in over a decade, but as far as WiFi drivers I think there is no
standards. Windows drivers are just like the vendor drivers for Linux: everyone is doing their
own thing. AFAIK only Linux has a framework for WiFi drivers and it should be praised for that as
it makes WiFi configuration so much more consistent (and therefore easier) for the user.

> > I am awaiting a patch from Alexandre which will add that same behavior
> > to rt2x00.
> 
> That would be great, thanks!

Yes that would be great indeed, no more patching hostapd, but there should be a warning about the fragile nature of this.

-- 
Christoph .J Thompson <cjsthompson@gmail.com>
