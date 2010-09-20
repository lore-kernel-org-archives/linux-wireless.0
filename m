Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:34025 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab0ITJJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 05:09:48 -0400
Subject: Re: [PATCH] Add 802.11a support configuration
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Gery Kahn <geryk@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1284973376-9396-1-git-send-email-geryk@ti.com>
References: <1284973376-9396-1-git-send-email-geryk@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 12:09:14 +0300
Message-ID: <1284973754.9281.52.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gery,

On Mon, 2010-09-20 at 11:02 +0200, ext Gery Kahn wrote:
> This patch adds ability to configure 802.11a support on wl1271.
> 
> The code is not tested enough, this is why marked as EXPERIMENTAL.
> 
> 
> Signed-off-by: Gery Kahn <geryk@ti.com>
> ---

Sorry for not answering your previous email.  I read it and was going to
reply to it later, but it got flooded down my inbox.

We already have a implemented a mechanism to decide whether to use 11a
or not at runtime.  It is still not upstream because I haven't been able
to test our forward-ports.  Now I got a beagle board with wl1271 and
I'll be able to test the upstream kernel and will submit everything
after I have tested.

Sorry for the trouble, but I have to NACK this.


-- 
Cheers,
Luca.

