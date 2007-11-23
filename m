Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:60220 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbXKWCZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 21:25:11 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IvOEA-0008MT-1V
	for linux-wireless@vger.kernel.org; Thu, 22 Nov 2007 21:25:10 -0500
Subject: Re: Belin FD7010 v7
From: Pavel Roskin <proski@gnu.org>
To: Vadim Peretokin <vperetokin@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <6995ca080711221804w7310134aw8a5902e45aa09942@mail.gmail.com>
References: <6995ca080711221239t2947765ds765fd933fce5de31@mail.gmail.com>
	 <1195781993.11966.27.camel@dv>
	 <6995ca080711221804w7310134aw8a5902e45aa09942@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 Nov 2007 21:25:07 -0500
Message-Id: <1195784707.11966.38.camel@dv> (sfid-20071123_022522_077280_82533E7A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2007-11-22 at 21:04 -0500, Vadim Peretokin wrote:
> Ahh I'm afraid no, I'm not quite there yet and need my laptop
> functional. But I'll let you know then when the next version of Ubuntu
> comes about, thank you!

Actually, there is a compatibility package with the latest wireless
drivers:
http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

It's much easier to compile.  No configuration is required.  Just run
"make" and then "make install" (as root).  Then use "modprobe rtl8180"
to load the driver.  Ubuntu will probably load it automatically after
reboot.  Linux 2.6.22 and newer is supported.  No kernel patching is
needed.  Just make sure to recompile the package when upgrading to the
next kernel.

Even if that doesn't work, it's possible to use ndiswrapper with the
Windows driver, so that you don't have to choose your OS because of
issues with just one driver.

-- 
Regards,
Pavel Roskin

