Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37073 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbZDXUPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 16:15:54 -0400
Date: Fri, 24 Apr 2009 16:14:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: jgarzik@pobox.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Masakazu Mokuno <mokuno@sm.sony.co.jp>
Subject: Re: [patch] net/ps3: Fix wireless AP connect error handling
Message-ID: <20090424201446.GD3309@tuxdriver.com> (sfid-20090424_221614_057924_AC7E8CBC)
References: <49D109B4.7020808@am.sony.com> <49F0EFB9.20709@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49F0EFB9.20709@am.sony.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 23, 2009 at 03:46:17PM -0700, Geoff Levand wrote:
> From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
> 
> This patch fixes the bug that the driver tries to continue to
> connect(associate) to AP even if gelic_wl_do_{wpa,wep}_setup() fails,
> 
> Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
> ---
> Hi John,
> 
> I didn't see this get merged in to 2.6.30 yet.  Could you let me know the status?
> 
> -Geoff

I have it queued for 2.6.31.  Does it cause a crash or other problem
serious enough to merit pushing it for 2.6.30?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
