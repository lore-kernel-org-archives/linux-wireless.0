Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58784 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1FISBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 14:01:24 -0400
Date: Thu, 9 Jun 2011 13:59:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-2.6 2011-06-08
Message-ID: <20110609175933.GA16802@tuxdriver.com> (sfid-20110609_200128_034135_61FA0B59)
References: <20110608194658.GD13036@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110608194658.GD13036@joana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 08, 2011 at 04:46:58PM -0300, Gustavo F. Padovan wrote:
> Hi John,
> 
> First round of fixed for 3.0! There are here a regression fix for 1.1 and
> earlier devices and a fix in the shutdown of SCO sockets.  Other 3 patches are
> warning shut up. And one byte leak to userspace fix.
> 
> Please pull, thanks!
> 
> 
> The following changes since commit 51e65257142a87fe46a1ce5c35c86c5baf012614:
> 
>   iwlegacy: fix channel switch locking (2011-06-08 14:19:05 -0400)
> 
> are available in the git repository at:
>   master.kernel.org:/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master
> 
> David Miller (2):

...

>       Bluetooth: Kill set but unused variable 'cmd' in cmtp_recv_capimsg()

Well, the patch submitter sounds familiar.  :-)  But killing an unused
variable isn't a bug fix.  It doesn't do any damage, but I suspect that
Dave expects to be held to the same standards as everyone else.

Can you drop that one (and reapply it for 3.1)?  Sorry for the trouble...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
