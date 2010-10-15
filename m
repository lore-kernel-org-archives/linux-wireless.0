Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42015 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab0JOUPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 16:15:07 -0400
Date: Fri, 15 Oct 2010 16:04:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-next-2.6 2010-10-13
Message-ID: <20101015200434.GB2438@tuxdriver.com>
References: <20101013034808.GA3205@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101013034808.GA3205@vigoh>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 13, 2010 at 12:48:08AM -0300, Gustavo F. Padovan wrote:
> Hi John,
> 
> Here goes the Bluetooth patches for the next merge window. In this
> patchset we have a new stream-oriented recvmsg() which is used in L2CAP
> and RFCOMM. Support for two new MacBookPro devices. A buffer overflow
> check for L2CAP to prevent frames exceeding the receiving MTU. All the
> rest are simple bugfixes. No big features this time.
> 
> One notable change is in the MAINTAINERS file, From now and on I'm going
> to maintain the Bluetooth trees as well as send the pull requests to you.
> Despite this maintenance change, Marcel will remain helping with patch
> review, and ACK/NAK in the Bluetooth subsystem as he always did. Not a
> big change in the end. ;)
> 
> Thanks,
> 
> The following changes since commit 29b4433d991c88d86ca48a4c1cc33c671475be4b:
> 
>   net: percpu net_device refcount (2010-10-12 12:35:25 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Pulled, thanks -- I plan to send a pull request to Dave later today.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
