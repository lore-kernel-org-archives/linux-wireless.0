Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:53253 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423345AbXBIWnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 17:43:47 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HFeRs-0000MZ-Vz
	for linux-wireless@vger.kernel.org; Fri, 09 Feb 2007 17:42:33 -0500
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
From: Pavel Roskin <proski@gnu.org>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
In-Reply-To: <45CCE3CA.4050904@linux.intel.com>
References: <45CCE3CA.4050904@linux.intel.com>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 17:43:41 -0500
Message-Id: <1171061021.7039.7.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, James!

On Fri, 2007-02-09 at 13:12 -0800, James Ketrenos wrote:

> You can find the new driver, and additional information about it, here:
> 
>    http://intellinuxwireless.org/iwlwifi.

I cannot get it through git:

$ git-clone http://intellinuxwireless.org/repos/iwlwifi.git
Initialized empty Git repository in /home/proski/src/iwlwifi/.git/
Cannot get remote repository information.
Perhaps git-update-server-info needs to be run there?

Perhaps git is right?  There is no info/refs there.

> You can find that package at:
> 
>    http://intellinuxwireless.org/d80211

I appreciate that you are doing this.  But it doesn't compile against
kernels compiled outside the tree:

grep: /lib/modules/2.6.20/build//include/linux/netdevice.h: No such file
or directory

Apparently it should be looking into /lib/modules/2.6.20/source as well.
That was a problem with the official ipw3945 drivers as well.

-- 
Regards,
Pavel Roskin

