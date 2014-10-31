Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39556 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaJaUPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 16:15:08 -0400
Date: Fri, 31 Oct 2014 16:06:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-10-31
Message-ID: <20141031200603.GD3768@tuxdriver.com> (sfid-20141031_211616_066857_1DAFD8CF)
References: <20141031182803.GA5772@t440s.P-661HNU-F1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141031182803.GA5772@t440s.P-661HNU-F1>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 31, 2014 at 08:28:03PM +0200, Johan Hedberg wrote:
> Hi John,
> 
> Here's the first bluetooth-next pull request for 3.19. The vast majority
> of patches are for ieee802154 from Alexander Aring with various fixes
> and cleanups. There are also several LE/SMP fixes as well as improved
> support for handling LE devices that have lost their pairing information
> (the patches from Alfonso). Jukka provides a couple of stability fixes
> for 6lowpan and Szymon conformance fixes for RFCOMM. For the HCI drivers
> we have one new USB ID for an Acer controller as well as a reset
> handling fix for H5.
> 
> Please let me know if there are any issues pulling. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit 61ed53deb1c6a4386d8710dbbfcee8779c381931:
> 
>   Merge tag 'ntb-3.18' of git://github.com/jonmason/ntb (2014-10-19 12:58:22 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to b509c02d0f31639dda90f9b7269668b86c9b25ef:
> 
>   Bluetooth: HCI H5 peer reset detection (2014-10-31 19:54:34 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
