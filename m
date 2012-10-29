Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56087 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab2J2USB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 16:18:01 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2171876bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2012 13:17:59 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Cliff McDiarmid <cliffhanger@gardener.com>
Subject: Re: RTL8188SU
Date: Mon, 29 Oct 2012 21:17:45 +0100
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <loom.20121028T233054-8@post.gmane.org> <201210291257.02249.chunkeey@googlemail.com> <loom.20121029T182405-382@post.gmane.org>
In-Reply-To: <loom.20121029T182405-382@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210292117.45399.chunkeey@googlemail.com> (sfid-20121029_211807_982532_194AE28D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, October 29, 2012 08:44:44 PM Cliff McDiarmid wrote:
> Christian Lamparter <chunkeey@...> writes:
> 
> > I put Josh' rtl8192su patches into a git repository
> > <https://github.com/chunkeey/rtl8192su> and started
> > adding things. This driver already does support monitor
> > mode and can connect to an legacy accesspoint. However 
> > as you can see the TODO list that comes with the driver
> > is quite long and a lot of important stuff is on it too.
> > 
> 
> Is it possible to use that driver with the rtl8188su?
The chip? Yes, it belongs to the same family as far as I can tell.
[In fact I have a device with a 8188SU chip too]

> I know the 8192su was replaced with the 8712u
This is probably something Larry has to answer. r8712u seems to
be a "cleaned-up" version of r8192s_usb (which is/was the
vendor driver?).

rtl8192su will make use of the rtlwifi framework [which is already
used by the drivers for rtl8192cu/ce/se/de...]. So it won't have
much in common with r8712u.

> but could I revert?
Well, this is getting confusing ;)
Can you explain what you want reverted?

Regards,
	Chr
