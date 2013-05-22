Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35016 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3EVSaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 14:30:10 -0400
Date: Wed, 22 May 2013 14:27:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@ml01.01.org>
Subject: Re: [GIT] [3.10] NFC fixes
Message-ID: <20130522182747.GG2113@tuxdriver.com> (sfid-20130522_203014_376150_EB2BD31B)
References: <20130521230711.GD4566@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130521230711.GD4566@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 22, 2013 at 01:07:11AM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> This is the first batch of NFC fixes for 3.10, and it contains:
> 
> - 3 fixes for the NFC MEI support:
>         * We now depend on the correct Kconfig symbol.
>         * We register an MEI event callback whenever we enable an NFC device,
>           otherwise we fail to read anything after an enable/disable cycle.
>         * We only disable an MEI device from its disable mey_phy_ops,
>           preventing useless consecutive disable calls.
> 
> - An NFC Makefile cleanup, as I forgot to remove a commented out line when
>   moving the LLCP code to the NFC top level directory.
> 
> The following changes since commit 6bb4880d9ef30375da4507aeabd6dc261a2c6c2b:
> 
>   ath9k: fix draining aggregation tid buffers (2013-05-17 14:31:09 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.10-1
> 
> for you to fetch changes up to e3a6b14ceda0207c3405c6266e5177a85c0db044:
> 
>   NFC: mei: Do not disable MEI devices from their remove routine (2013-05-21 10:48:41 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
