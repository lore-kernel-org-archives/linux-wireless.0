Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55095 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754144AbZIPRRf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 13:17:35 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Markus Becker <mab@comnets.uni-bremen.de>
Subject: Re: linuxwireless Driver information: zd1211rw
Date: Wed, 16 Sep 2009 19:17:36 +0200
Cc: linux-wireless@vger.kernel.org
References: <200909161804.04296.mab@comnets.uni-bremen.de>
In-Reply-To: <200909161804.04296.mab@comnets.uni-bremen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909161917.37581.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wednesday 16 September 2009, Markus Becker wrote:
> Hello,
> 
> is the information on the page 
> http://www.linuxwireless.org/en/users/Drivers/zd1211rw about the Debian 
> firmware package still true?
> 
> "Firmware is pulled from userspace, get the files here.
> Debian users beware: don't use the the zd1211-firmware package, as this is for 
> Debian's fork of the vendor-based driver"
> 
> The current debian package contains the same files as in the link 
> http://sourceforge.net/project/showfiles.php?group_id=129083

zd1211-firmware (2.16.0.0-0.1) unstable; urgency=low

  * NMU
[...]
  * Use symlink farm to provide the firmware in the locations used by the
    zd1211rw in-kernel driver, as well as the zd1211 extra-kernel driver.
    Closes: #383604
  * Should be suitable for etch release now. Closes: #411912
[...]

 -- Joey Hess <joeyh@debian.org>  Wed, 21 Feb 2007 15:09:09 -0500

(the symlink farm is gone by now and the the package only keeps 
 compatibility with in-kernel zd1211rw, all what's left is the version
 number derived from the vendor-based driver)

In other words, the past two major Debian releases (shipping with kernel 
2.6.18/ etch and 2.6.26/ lenny respectively) had a working firmware package
available from the non-free section.

Kernel 2.6.18, which was the first to ship with zd1211rw, was released on 
Tue, Sep 19 20:42:06 2006 -0700, so the advice pointing at a broken 
firmware package in Debian's unreleased branches was true for roughly 4 
months and never affected a released version (sarge shipped with kernel 
2.6.8, etch with 2.6.18 and zd1211-firmware 2.16.0.0-0.1).

Regards
	Stefan Lippers-Hollmann
