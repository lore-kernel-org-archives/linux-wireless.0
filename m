Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:58869 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965108AbXBSWav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:30:51 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HJH0e-0003yl-I9
	for linux-wireless@vger.kernel.org; Mon, 19 Feb 2007 17:29:24 -0500
Subject: Re: Kernel bug in bcm43xx-d80211
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alex Davis <alex14641@yahoo.com>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1171923128.15489.35.camel@johannes.berg>
References: <358127.50930.qm@web50203.mail.yahoo.com>
	 <1171923128.15489.35.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 17:30:47 -0500
Message-Id: <1171924247.2257.31.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-02-19 at 23:12 +0100, Johannes Berg wrote:
> On Mon, 2007-02-19 at 13:48 -0800, Alex Davis wrote:
> > I go the following Oops with the latest wireless-dev git when starting wpa_supplicant:
> > 
> > Feb 19 16:17:42 boss kernel: [  377.359573] BUG: unable to handle kernel NULL pointer dereference
> > at virtual address 00000002
> 
> Probably caused by my recent changes that accidentally broke d80211
> pretty much completely. Patches are on the linux-wireless mailing list.

Johannes, would it be possible to commit patches faster, please?  Now
that I told Michael about git-update-server-info, his changes are
downloadable as soon as he makes a commit.  wireless-dev.git, on the
other hand, is a mess and has been for some time (since Friday, I
believe).

It is a problem for projects like DadWifi that recommend to use the top
of wireless-dev.git.  Yes, I know, breakage is unavoidable to a certain
degree, but it shouldn't come to the situation when the patches are
known, nobody objects, yet the repository stays broken and all newcomers
have to be told about the problem.

That's not to offend you or anyone.  It's just something that would help
a lot.

-- 
Regards,
Pavel Roskin

