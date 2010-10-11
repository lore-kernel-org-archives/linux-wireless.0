Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:29359 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab0JKK5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 06:57:09 -0400
Subject: Re: [PATCH v2] wl1271: ref_clock cosmetic changes
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Gery Kahn <geryk@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286287745-24966-1-git-send-email-geryk@ti.com>
References: <1286287745-24966-1-git-send-email-geryk@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 13:56:46 +0300
Message-ID: <1286794606.16901.24.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-05 at 16:09 +0200, ext Gery Kahn wrote:
> Cosmetic cleanup for ref_clock code while configured by board.
> 
> Signed-off-by: Gery Kahn <geryk@ti.com>
> ---
> v2: added enum for wl12xx boards reference clock

Applied to wl12xx/wl12xx-next branch.  Thanks!

This will take a little while to show up in wl12xx/master because I need
to merge some conflicts first.


-- 
Cheers,
Luca.

