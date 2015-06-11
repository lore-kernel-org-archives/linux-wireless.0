Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34920 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbbFKIjo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 04:39:44 -0400
Message-ID: <1434011982.1915.4.camel@sipsolutions.net> (sfid-20150611_104055_299345_C40ACD8D)
Subject: Re: values in /proc/net/wireless are static, doesn't change;
 iwlwifi, Intel 6205
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Lublin <quite@hack.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Jun 2015 10:39:42 +0200
In-Reply-To: <loom.20150611T103011-578@post.gmane.org> (sfid-20150611_103051_260554_CB70491A)
References: <loom.20150611T094911-428@post.gmane.org>
	  (sfid-20150611_100009_243262_EFBCBBEB) <1434009970.1915.3.camel@sipsolutions.net>
	 <loom.20150611T103011-578@post.gmane.org>
	 (sfid-20150611_103051_260554_CB70491A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-06-11 at 08:30 +0000, Daniel Lublin wrote:
> > The fix just went into net.git.
> 
> Aha! There you go. Where do I find it? Beginner kernel git diver...

https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=9c5a18a31b321f120efda412281bb9f610f84aa0

johannes

