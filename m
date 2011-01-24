Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50866 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1AXVpg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 16:45:36 -0500
Subject: Re: [PATCH] wl12xx: disable auto-arp
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295893143-6981-1-git-send-email-eliad@wizery.com>
References: <1295893143-6981-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 23:45:45 +0200
Message-ID: <1295905545.4430.6.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-24 at 19:19 +0100, Eliad Peller wrote:
> The auto-arp feature sometimes has unexpected side effects (e.g. firmware
> crashes, no ARP replies, etc.)
> disable it until it will be solved.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Damn that we're having problems with this feature again. :( It looked so
promising!

Anyway, applied this, let's hope the issue can be fixed in the near
future.

-- 
Cheers,
Luca.

