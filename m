Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48448 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbaG2OaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 10:30:11 -0400
Date: Tue, 29 Jul 2014 10:26:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org, gustavo@padovan.org
Subject: Re: pull request: bluetooth-next 2014-07-28
Message-ID: <20140729142604.GD13090@tuxdriver.com> (sfid-20140729_163030_509135_5A1CA624)
References: <20140728201610.GA29494@t440s.P-661HNU-F1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140728201610.GA29494@t440s.P-661HNU-F1>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 28, 2014 at 11:16:10PM +0300, Johan Hedberg wrote:
> Hi John,
> 
> This pull request should replace the previous one that Gustavo made
> (bluetooth-next 2014-07-23).
> 
> To quote Gustavo from his previous request:
> 
> "Some last minute fixes for -next. We have a fix for a use after free in
> RFCOMM, another fix to an issue with ADV_DIRECT_IND and one for ADV_IND with
> auto-connection handling.  Last, we added support for reading the codec and
> MWS setting for controllers that support these features."
> 
> Additionally there are fixes to LE scanning, an update to conform to the 4.1
> core specification as well as fixes for tracking the page scan state. All
> of these fixes are important for 3.17.
> 
> Let me know if there are any issues. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit c2aef6e8cbebd60f79555baeb9266e220f135a44:
> 
>   Bluetooth: Add support for Broadcom device of Asus Z97-DELUXE motherboard (2014-07-21 15:07:08 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to 3bd2724010a51d5d15afa8065ac3c5fab3725499:
> 
>   Bluetooth: Fix incorrectly disabling page scan when toggling connectable (2014-07-28 20:13:32 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
