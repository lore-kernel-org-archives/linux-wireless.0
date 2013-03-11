Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3CKOjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 10:39:52 -0400
Message-ID: <1363012784.5284.5.camel@jlt4.sipsolutions.net> (sfid-20130311_153955_181897_B8A7A3C7)
Subject: Re: [PATCH] mac80211: Enable sw scan with chan context
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 11 Mar 2013 16:39:44 +0200
In-Reply-To: <513DE4BB.9010104@posedge.com>
References: <513DE4BB.9010104@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-11 at 19:35 +0530, Mahesh Palivela wrote:
> From: Mahesh Palivela <maheshp@posedge.com>
> 
> Enable software scan with channel context in use.

I don't think this will even work, but even if it did I think it's too
painful with off-channel etc.

johannes

