Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34716 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbbFKIGP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 04:06:15 -0400
Message-ID: <1434009970.1915.3.camel@sipsolutions.net> (sfid-20150611_100624_293302_BB196B41)
Subject: Re: values in /proc/net/wireless are static, doesn't change;
 iwlwifi, Intel 6205
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Lublin <quite@hack.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Jun 2015 10:06:10 +0200
In-Reply-To: <loom.20150611T094911-428@post.gmane.org> (sfid-20150611_100009_243262_EFBCBBEB)
References: <loom.20150611T094911-428@post.gmane.org>
	 (sfid-20150611_100009_243262_EFBCBBEB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-06-11 at 07:55 +0000, Daniel Lublin wrote:
> I'm on a thinkpad X230 with Intel Advanced-N 6205 card, iwlwifi driver. 
> 
> Reading /proc/net/wireless, I find that the values there does not change. No 
> matter me moving around, changing distance to my AP. On my old machine (X60), 
> I was used to sometimes using for example wavemon(1) to find out where I get 
> the best reception. I this a limitation of my network card, driver, or some 
> combitation? As designed, or a flaw?

The fix just went into net.git.

johannes

