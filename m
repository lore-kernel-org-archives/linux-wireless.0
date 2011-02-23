Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:51387 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755399Ab1BWNxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 08:53:06 -0500
Subject: Re: [patch] wl12xx: change type from u8 to int
From: Luciano Coelho <coelho@ti.com>
To: Dan Carpenter <error27@gmail.com>
Cc: shahar_levi@ti.com, "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20110207164742.GE4384@bicker>
References: <20110207164742.GE4384@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 15:52:50 +0200
Message-ID: <1298469170.2104.21.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-07 at 19:47 +0300, Dan Carpenter wrote:
> ret is used to store int types.  Using an u8 will break the error
> handling.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied, thanks Dan!

-- 
Cheers,
Luca.

