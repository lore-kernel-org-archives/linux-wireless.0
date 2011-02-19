Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:24878 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab1BSBaD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 20:30:03 -0500
Date: Fri, 18 Feb 2011 17:30:01 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Naveen Singh <Naveen.Singh@Atheros.com>,
	Jack Yang <Jack.Yang@Atheros.com>
CC: Samuel Chang <Samuel.Chang@Atheros.com>,
	Joe Perches <joe@perches.com>, Jerry Hu <Jerry.Hu@Atheros.com>,
	Maggie Huang <Maggie.Huang@Atheros.com>,
	Vipin Mehta <Vipin.Mehta@Atheros.com>,
	<linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>, Greg KH <greg@kroah.com>,
	<mcgrof@gmail.com>
Subject: ath6kl - coordination of development
Message-ID: <20110219013001.GM15610@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A lot of work is going to go into ath6kl soon. To help avoid conflicts
with it is of critical importance to coordinate and communicate.

The Linux kernel policy on staging drivers is that they will be removed
from the Linux kernel if they do not get any cleanup attention. We are
addressing that now but the cleanups will cause conflicts with any other
wide spread change. Joe has some large amount of cleanup patches he has
written with some scripts and will soon send them out. To help avoid
conflicts the hope is we will limit the cleanups we do to a few set of
patches at a time. All these changes will be as atomic and small as
possible. Our goal is to eventually move ath6kl out to proper placement
in the kernel, but this will take some time.

Note that if you are doing development on a side branch it is incorrect,
you should post your patches targetted upstream *first*. To hack on ath6kl
you will need to:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git
git checkout -b ath6kl-dev origin/staging-next

To track our TODO we will use the wiki:

http://wireless.kernel.org/en/users/Drivers/ath6kl

To coordinate development we will talk on IRC:

Channel: #ath6kl
Server: irc.freenode.net

Anyone looking to coordinate development or get patches into ath6kl in
any way shape or form is recommended to use IRC to coordinate with
myself, Naveen and Joe. Vipin is off on vacation for a while now.

Joe -- I know you have a large series pending, but perhaps we can
coordinate to only send batches in 20 ? Or Greg do you have any preference?

Naveen, please work with me on your patches. I'd like to see Joe's patches
merged first. I take it Jack Yang's patches are identical to the ones you are
going to work on?

  Luis
