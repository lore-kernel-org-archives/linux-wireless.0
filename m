Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48819 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab3FRTAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 15:00:10 -0400
Date: Tue, 18 Jun 2013 14:45:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull request: TI wireless drivers 2013-06-18 (for 3.11)
Message-ID: <20130618184538.GB12696@tuxdriver.com> (sfid-20130618_210021_669239_035E4457)
References: <1371552937.10702.15.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371552937.10702.15.camel@cumari.coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 18, 2013 at 01:55:37PM +0300, Luciano Coelho wrote:
> Hi John,
> 
> Here are a few patches intended for 3.11.  There's nothing major.  A
> bunch of bug fixes here and there, a hardware bug workaround and some
> small clean-ups.
> 
> Please let me know if you have any problems with it!
> 
> The following changes since commit 1105a13bb8ad29cf83d46989ee462d196038be87:
> 
>   orinoco_usb: fix memory leak in ezusb_access_ltv() when device disconnected (2013-06-14 13:37:16 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville
> 
> for you to fetch changes up to 789e90e567d7d93edc1b2001d17209c21cc37850:
> 
>   net: wireless: wl1251: Fix commenting style (2013-06-17 12:24:09 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
