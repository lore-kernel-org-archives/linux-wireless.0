Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:62716 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763968AbXHVSKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 14:10:21 -0400
Received: by wa-out-1112.google.com with SMTP id v27so271532wah
        for <linux-wireless@vger.kernel.org>; Wed, 22 Aug 2007 11:10:20 -0700 (PDT)
Message-ID: <5b9417770708221110w4c6a7155u8f41e9ea5a0a4a85@mail.gmail.com>
Date: Wed, 22 Aug 2007 13:10:20 -0500
From: "John H." <mistamaila@gmail.com>
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: ALERT: firmware change for b43
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	"Broadcom Linux" <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <46CC7B89.7090906@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <46C89BF1.5060306@lwfinger.net>
	 <20070822145257.GA2926@tuxdriver.com> <46CC5568.5000709@lwfinger.net>
	 <20070822171805.GD2926@tuxdriver.com> <46CC7B89.7090906@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm sorry, I am coming into this rather late.  is this the latest
firmware for bcm43xx devices at version 4?

On 8/22/07, Larry Finger <larry.finger@lwfinger.net> wrote:
> John W. Linville wrote:
> > On Wed, Aug 22, 2007 at 10:25:28AM -0500, Larry Finger wrote:
> >> John W. Linville wrote:
> >>> On Sun, Aug 19, 2007 at 02:37:21PM -0500, Larry Finger wrote:
> >>>> Just in case you missed the details, the latest set of changes to b43
> >>>> queued by Michael will require
> >>>> a new version of fwcutter, now called b43-fwcutter, and a new extraction
> >>>> of your firmware.
> >>> Is there a tarball available for download, as with bcm43xx-fwcutter?
> >>> It would be handy for packaging.
> >> The new code is in the svn repository; however, a tarball would not be a
> >> problem. Is source sufficient, or would you want an executable?
> >
> > Source would be fine, equivalent to what is here:
> >
> >       http://download.berlios.de/bcm43xx/bcm43xx-fwcutter-006.tar.bz2
>
> I don't have nor want write access at berlios.de.  The file you want is:
>
> ftp://lwfinger.dynalias.org/patches/b43-fwcutter-008.tar.bz2.
>
> Larry
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>
