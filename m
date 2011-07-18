Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59687 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1GRHqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 03:46:18 -0400
Subject: Re: IEEE802.11 BEB Implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Anbarasan <anbarasans85@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110717T202533-832@post.gmane.org> (sfid-20110717_203020_523344_08EE9078)
References: <loom.20110717T202533-832@post.gmane.org>
	 (sfid-20110717_203020_523344_08EE9078)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 09:46:15 +0200
Message-ID: <1310975175.3942.3.camel@jlt3.sipsolutions.net> (sfid-20110718_094626_906358_80FBDD2C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-07-17 at 18:29 +0000, Anbarasan wrote:

> Following is a comment in the file (driver/net/wireless/iwl-commands.h):
> /*Device will automatically increase contention window by (2*CW) + 1 for each 
> transmission retry.  Device uses cw_max as a bit mask, ANDed with new CW  value,
> to cap the CW value.*/
> 
> The above is the BEB and I am looking for this implementation. I could not find
> it. Kindly help. (I have a Intel Wireless card.)

Isn't "Device will" and "Device uses" obvious? The card does it, you
cannot modify this implementation.

johannes

