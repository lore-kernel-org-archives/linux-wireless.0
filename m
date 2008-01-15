Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61737 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbYAOS1o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2008 13:27:44 -0500
Subject: Re: [PATCH] b43: Add support for new firmware
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200801131420.52995.mb@bu3sch.de>
References: <200801131420.52995.mb@bu3sch.de>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 13:27:42 -0500
Message-Id: <1200421662.17542.32.camel@dv> (sfid-20080115_182747_452841_CFD952BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sun, 2008-01-13 at 14:20 +0100, Michael Buesch wrote:
> This patch adds support for new firmware.
> Old firmware is still supported until July 2008.
> 
> To get new firmware, go to
> ftp://ftp.linksys.com/opensourcecode/wrt150nv11/1.51.3/
> and download the tarball. We don't have a smaller tarball, yet.
> That will be fixed later.

I have finally found some time and hardware to test it, but the tarball
is overwhelming at its 186M.  And the worst thing, the server
disconnected after 30M and appears to be down right now.  P.S. It's up,
ETA is 48 minutes.

There were two files there.  I hope either is fine.  I'm trying to
download WRT150NV11_v1.51.3_ETSI.tgz

Cannot we petition Linksys to put wl_ap.o outside the tarball?  Or maybe
Broadcom could do it?

Even a zip file would be better.  It's possible to cut a part of the zip
file and uncompress it with gzip.

It's really a travesty of open source.  The file is "available", but you
have do download 186M of useless (for me at least) mips compilers and
other stuff.  And I have a relatively good connection.

> You can extract firmware out of the "wl_ap.o" file contained
> in this tarball using latest fwcutter. You must pass the option
> --unsupported to fwcutter.
> Fwcutter-010 with official support for a new firmware image will
> be released soon.

Do you know that the Subversion repository of fwcutter has no files at
all?  I mean svn://svn.berlios.de/bcm43xx/trunk

Yes, I will try --unsupported, with version 009.

-- 
Regards,
Pavel Roskin
