Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53564 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3BROmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 09:42:10 -0500
Received: by mail-bk0-f46.google.com with SMTP id j5so2619529bkw.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 06:42:09 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] linux-firmware: add carl9170 firmware
Date: Mon, 18 Feb 2013 15:42:05 +0100
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Dan =?iso-8859-15?q?Hor=E1k?= <dan@danny.cz>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"Stefan Lippers-Hollmann" <s.L-H@gmx.de>
References: <1342353398-3147-1-git-send-email-xose.vazquez@gmail.com> <201301180052.07145.chunkeey@googlemail.com> <1361157348.5374.538.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1361157348.5374.538.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201302181542.05471.chunkeey@googlemail.com> (sfid-20130218_154215_515728_5736847E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, February 18, 2013 04:15:48 AM Ben Hutchings wrote:
> Sorry for the delay in replying to this.
I see. Well, thanks for the response.

> On Fri, 2013-01-18 at 00:52 +0100, Christian Lamparter wrote:
> > On Thursday, January 17, 2013 10:26:44 PM Ben Hutchings wrote:
> > > I'm happy to take either a single patch for the new release or
> > > one patch for each commit in your repository, whichever you prefer.
> > Would it be possible to attach a carl9170fw-x.y.z-source.tar.xz/bz2/gz/zip
> > along the carl9170-1.fw binary instead of the source dump in carl9170fw/?
> 
> Perhaps, but what would be the benefit?
Actually, I was thinking that having a single source.tar would be easier
to handle and it would cause less clutter (Yeah, I've seen people do cp -r
linux-firmware.git/* into /lib/firmware/. And in this case - I think - a
source.tar.xyz is less of an eyesore...). Also a single source.tar can be
easily signed and verified. But of course, it's your tree and therefore
it's your call.

[Note: Unless there is a bug that needs to be fixed ASAP, I'll wait for
gcc 4.8 to be ready before I make carl9170fw 1.9.8. So, there is plenty
of time to decide what to do.]

Regards
	Christian
