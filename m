Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:51189 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbXKWBj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 20:39:57 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IvNWN-0006Ot-SB
	for linux-wireless@vger.kernel.org; Thu, 22 Nov 2007 20:39:55 -0500
Subject: Re: Belin FD7010 v7
From: Pavel Roskin <proski@gnu.org>
To: Vadim Peretokin <vperetokin@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <6995ca080711221239t2947765ds765fd933fce5de31@mail.gmail.com>
References: <6995ca080711221239t2947765ds765fd933fce5de31@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 Nov 2007 20:39:53 -0500
Message-Id: <1195781993.11966.27.camel@dv> (sfid-20071123_014001_156927_D23D0C84)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-11-22 at 15:39 -0500, Vadim Peretokin wrote:

> But that is very ambiguous. Does that mean if anything is being done
> to make this card work, do you know?

The mac80211 driver for rtl8180/rtl8185 appeared in the "everything"
branch of the wireless-2.6 repository just weeks ago.  If you are ready
to recompile the kernel, use this to get the repository:

git-clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
cd wireless-2.6
git-checkout --track -b everything remotes/origin/everything

Make sure CONFIG_RTL8180 is enabled in .config file.

-- 
Regards,
Pavel Roskin

