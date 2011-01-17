Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1AQR6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 12:58:32 -0500
Subject: Re: [PATCH] wl12xx: free firmware after booting the chip
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1295284675-30029-1-git-send-email-eliad@wizery.com>
References: <1295284675-30029-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 18:58:28 +0100
Message-ID: <1295287108.3726.49.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 19:17 +0200, Eliad Peller wrote:
> There is no need to save the fw in memory after it has been
> uploaded to the chip.

Are you sure it's not needed for resume? At which point userspace isn't
up so you can't load it.

johannes

