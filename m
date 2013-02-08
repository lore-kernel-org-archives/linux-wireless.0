Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60858 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946915Ab3BHTp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 14:45:29 -0500
Date: Fri, 8 Feb 2013 14:43:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [GIT] [3.9] NFC pull request
Message-ID: <20130208194324.GI2116@tuxdriver.com> (sfid-20130208_204535_002201_105F70A0)
References: <20130208132335.GB20996@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130208132335.GB20996@sortiz-mobl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 08, 2013 at 02:23:35PM +0100, Samuel Ortiz wrote:
> Hi John,
> 
> This is the second NFC pull request for 3.9.
> 
> We have:
> 
> - A few pn533 fixes on top of Waldemar refactorization of the driver, one of
>   them fixes target mode.
> 
> - A new driver for Inside Secure microread chipset. It supports two
>   physical layers: i2c and MEI. The MEI one depends on a patchset that's
>   been sent to Greg Kroah-Hartman for inclusion into the 3.9 kernel [1]. The
>   dependency is a KConfig one which means this code is not buildable as long
>   as the MEI API is not usptream.
> 
> Thanks in advance for pulling them in.
> 
> [1] https://lkml.org/lkml/2013/2/8/165
> 
> 
> The following changes since commit 9ebea3829fac7505e0cd2642fbd13cfa9c038831:
> 
>   Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless (2013-01-28 13:54:03 -0500)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.9-2
> 
> for you to fetch changes up to 52f2eaeec11c16c219f0e99b8496fbba86889830:
> 
>   NFC: pn533: Fix target polling mode (2013-02-08 12:18:48 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
