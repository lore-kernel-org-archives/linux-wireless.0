Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46858 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbaLAVAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 16:00:13 -0500
Date: Mon, 1 Dec 2014 15:50:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-11-27
Message-ID: <20141201205027.GB7266@tuxdriver.com> (sfid-20141201_220020_514784_FC39978D)
References: <20141127103606.GA11964@t440s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141127103606.GA11964@t440s>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 27, 2014 at 12:36:06PM +0200, Johan Hedberg wrote:
> Hi John,
> 
> Here's one more bluetooth-next pull request for 3.19:
> 
>  - Minor cleanups for ieee802154 & mac802154
>  - Fix for the kernel warning with !TASK_RUNNING reported by Kirill A.
>    Shutemov
>  - Support for another ath3k device
>  - Fix for tracking link key based security level
>  - Device tree bindings for btmrvl + a state update fix
>  - Fix for wrong ACL flags on LE links
> 
> Please let me know if there are any issues pulling. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit a86c02ea38c53b695209b1181f9e2e18d73eb4e8:
> 
>   Bluetooth: Add support for Broadcom BCM20702A1 variant (2014-11-18 08:32:14 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to f6af675ef5489c69fc3d4faf8c6f477df3cbf8b9:
> 
>   Bluetooth: Automatically flushable packets aren't allowed on LE links (2014-11-27 12:12:27 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
