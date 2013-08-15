Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49225 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab3HOUAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 16:00:16 -0400
Date: Thu, 15 Aug 2013 15:56:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.12] NFC updates
Message-ID: <20130815195610.GG2133@tuxdriver.com> (sfid-20130815_220022_041849_809FA004)
References: <20130814230448.GB11055@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130814230448.GB11055@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 15, 2013 at 01:04:48AM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> This is the first NFC pull request for the 3.12 release.
> 
> With this one we have:
> 
> - A few pn533 improvements and minor fixes. Testing our pn533 driver
>   against Google's NCI stack triggered a few issues that we fixed now.
>   We also added Tx fragmentation support to this driver.
> 
> - More NFC secure element handling. We added a GET_SE netlink command
>   for getting all the discovered secure elements, and we defined 2
>   additional secure element netlink event (transaction and connectivity).
>   We also fixed a couple of typos and copy-paste bugs from the secure
>   element handling code.
> 
> - Firmware download support for the pn544 driver. This chipset can enter a
>   special mode where it's waiting for firmware blobs to replace the
>   already flashed one. We now support that mode.
> 
> The following changes since commit d1e2586f484dfc36eee2b2d3a6c6c77be67ca492:
> 
>   mwifiex: fix build error when CONFIG_PM is not set (2013-08-12 14:36:55 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.12-1
> 
> for you to fetch changes up to 39525ee1dc78ca1f5f2fb1f764f7a141005fe440:
> 
>   NFC: Update secure element state (2013-08-14 01:13:40 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
