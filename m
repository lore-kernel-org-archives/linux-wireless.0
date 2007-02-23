Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:51896 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXBWFpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 00:45:03 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HKTDO-0001qE-M3
	for linux-wireless@vger.kernel.org; Fri, 23 Feb 2007 00:43:30 -0500
Subject: Re: iwlwifi warnings
From: Pavel Roskin <proski@gnu.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20070221193836.GC3732@elf.ucw.cz>
References: <45CCE3CA.4050904@linux.intel.com>
	 <20070213181313.GA5350@ucw.cz> <45D254C6.7050401@linux.intel.com>
	 <20070219224432.GD21199@elf.ucw.cz> <45DBE559.8080903@osdl.org>
	 <20070221193836.GC3732@elf.ucw.cz>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 00:44:58 -0500
Message-Id: <1172209498.20817.54.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-02-21 at 20:38 +0100, Pavel Machek wrote:
> "Normal" installation procedure has too many steps in my eyes, and
> combined git tree is not available, so I was waiting for merge at
> least into -wirelessdev tree.

"make patch_kernel" would patch the kernel from wireless-dev.git.  If
the Linux source tree is not configured, just run "make distclean" after
that (or apply my patch from the previous post in the ipw3945-devel
list).

You can use StGIT for convert the changes made by "make patch_kernel" to
a local patch so that updating from the upstream git repository is still
possible with "stg pull".

No need to wait for anything.

-- 
Regards,
Pavel Roskin

