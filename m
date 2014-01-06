Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbaAFPTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 10:19:54 -0500
Message-ID: <1389021591.5891.27.camel@jlt4.sipsolutions.net> (sfid-20140106_161959_383665_2B128B5E)
Subject: Re: [PATCH] mac80211: remove redundant flag check
From: Johannes Berg <johannes@sipsolutions.net>
To: fred.chou.nd@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Jan 2014 16:19:51 +0100
In-Reply-To: <52b8191b.6ade440a.6499.ffff91da@mx.google.com> (sfid-20131223_120607_181506_F3036311)
References: <52b8191b.6ade440a.6499.ffff91da@mx.google.com>
	 (sfid-20131223_120607_181506_F3036311)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-23 at 19:07 +0800, fred.chou.nd@gmail.com wrote:
> From: Fred Chou <fred.chou.nd@gmail.com>
> 
> It's not necessary to check a flag setting and then
> set it anyway. The outer condition check is redundant
> in the code below. Remove the outer if.

It may be redundant in theory, but I think it makes the code easier to
read, and it avoids all the other checks and the flags write. I don't
think I want to apply this.

johannes

