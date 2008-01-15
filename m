Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:41344 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751451AbYAOTWs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2008 14:22:48 -0500
Date: Tue, 15 Jan 2008 20:15:38 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Pavel Roskin <proski@gnu.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Add support for new firmware
Message-ID: <20080115201538.5e4347f9@morte> (sfid-20080115_192251_865184_44AC7D2E)
In-Reply-To: <1200421662.17542.32.camel@dv>
References: <200801131420.52995.mb@bu3sch.de>
	<1200421662.17542.32.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 15 Jan 2008 13:27:42 -0500
Pavel Roskin <proski@gnu.org> wrote:

> I have finally found some time and hardware to test it, but the tarball
> is overwhelming at its 186M.  And the worst thing, the server
> disconnected after 30M and appears to be down right now.  P.S. It's up,
> ETA is 48 minutes.
> 
> There were two files there.  I hope either is fine.  I'm trying to
> download WRT150NV11_v1.51.3_ETSI.tgz
> 
> Cannot we petition Linksys to put wl_ap.o outside the tarball?  Or maybe
> Broadcom could do it?

Good luck. ;) The only long-term lasting solution I see is to put more
effort on an open firmware. The instruction set has been figured out, we
just lack people and time there.

> Do you know that the Subversion repository of fwcutter has no files at
> all?  I mean svn://svn.berlios.de/bcm43xx/trunk
> 
> Yes, I will try --unsupported, with version 009.

fwcutter development now happens here:
http://bu3sch.de/gitweb?p=b43-tools.git;a=summary

Maybe we should add this along with git URLs on linuxwireless.org.


--
Ciao
Stefano
