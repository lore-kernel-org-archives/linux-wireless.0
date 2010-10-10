Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab0JJThU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 15:37:20 -0400
Subject: Re: Bug#599345: linux-image-2.6.32-5-amd64: iwlagn allocation
 failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Julien Cristau <jcristau@debian.org>, 599345@bugs.debian.org,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1286737393.2955.225.camel@localhost>
References: <20101006191947.GA3036@radis.liafa.jussieu.fr>
	 <1286402043.2955.81.camel@localhost>
	 <1286437870.3657.16.camel@jlt3.sipsolutions.net>
	 <1286737393.2955.225.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 21:37:12 +0200
Message-ID: <1286739432.3547.83.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-10-10 at 20:03 +0100, Ben Hutchings wrote:

> > I have, however much more recently than that kernel, cleaned this up in
> > commit ff0d91c3eea6e25b47258349b455671f98f1b0cd -- this particular
> > allocation is now 2048 or 4096 bytes depending on the architecture (32
> > vs 64 bit pointers). If you want to backport this, there are two or
> > three more commits right before it that would probably be required.
> 
> It seems like we can get away with a much smaller change though.
> Julien, could you test this patch?

Yes, that patch seems alright -- we can't end up using more than one.

johannes

