Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60856 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946902Ab3BHTp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 14:45:29 -0500
Date: Fri, 8 Feb 2013 14:42:06 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, balbi@ti.com
Subject: Re: pull request: TI wireless drivers 2013-02-08 (for 3.9)
Message-ID: <20130208194206.GH2116@tuxdriver.com> (sfid-20130208_204534_187256_873DE329)
References: <1360315992.12803.33.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360315992.12803.33.camel@cumari.coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 08, 2013 at 11:33:12AM +0200, Luciano Coelho wrote:
> Hi John,
> 
> A few more patches intended for 3.9.  Mostly some clean-ups I've been
> doing to make it easier to support device-tree.  Also including one bug
> fix for wl12xx where the rates we advertise were wrong and an update in
> the wlconf structure to support newer firmwares.
> 
> Please let me know if you have any problems with it!
> 
> 
> The following changes since commit b26f5f09ebdeb85ab152344cc1d6d484a3ce967d:
> 
>   rtlwifi: rtl8723ae: Fix W=1 compile warnings (2013-02-01 14:27:27 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville
> 
> for you to fetch changes up to 9c3a8d99346040010a82ae8088b055f85cf8a2e9:
> 
>   wlcore: fix wrong remote rates when starting STA role (2013-02-08 10:20:16 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
