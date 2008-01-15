Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:39117 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbYAOWWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2008 17:22:52 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] b43: Add support for new firmware
Date: Tue, 15 Jan 2008 23:21:40 +0100
Cc: Pavel Roskin <proski@gnu.org>,
	John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200801131420.52995.mb@bu3sch.de> <1200421662.17542.32.camel@dv> <20080115201538.5e4347f9@morte>
In-Reply-To: <20080115201538.5e4347f9@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801152321.41073.mb@bu3sch.de> (sfid-20080115_222255_937924_4D14BC40)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 January 2008 20:15:38 Stefano Brivio wrote:
> On Tue, 15 Jan 2008 13:27:42 -0500
> Pavel Roskin <proski@gnu.org> wrote:
> 
> > I have finally found some time and hardware to test it, but the tarball
> > is overwhelming at its 186M.  And the worst thing, the server
> > disconnected after 30M and appears to be down right now.  P.S. It's up,
> > ETA is 48 minutes.
> > 
> > There were two files there.  I hope either is fine.  I'm trying to
> > download WRT150NV11_v1.51.3_ETSI.tgz
> > 
> > Cannot we petition Linksys to put wl_ap.o outside the tarball?  Or maybe
> > Broadcom could do it?
> 
> Good luck. ;) The only long-term lasting solution I see is to put more
> effort on an open firmware. The instruction set has been figured out, we
> just lack people and time there.

We already have a better file on an openwrt server that will be the
officially supported one soon.
I just have to create a new fwcutter tarball and link from linuxwireless.org
to it. I already added support for the file to fwcutter git.
See Stefano's comment below.

> > Do you know that the Subversion repository of fwcutter has no files at
> > all?  I mean svn://svn.berlios.de/bcm43xx/trunk
> > 
> > Yes, I will try --unsupported, with version 009.
> 
> fwcutter development now happens here:
> http://bu3sch.de/gitweb?p=b43-tools.git;a=summary

Yep, the berlios stuff is dropped completely, except the download
section for the fwcutter tarballs. But that may also change in future.
We will announce that on linuxwireless.org.

> Maybe we should add this along with git URLs on linuxwireless.org.

Please do it, if you feel so.

-- 
Greetings Michael.
