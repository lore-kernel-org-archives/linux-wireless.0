Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51839 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbbERJYU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 05:24:20 -0400
Message-ID: <1431941058.2719.1.camel@sipsolutions.net> (sfid-20150518_112435_669850_9D57925D)
Subject: Re: [PATCH] mac80211: Fix power save state stuck in ACTIVE caused
 by race between suspend and Tx packet.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 18 May 2015 11:24:18 +0200
In-Reply-To: <CABPxzYJ-3ctYOdek4RGkt95EKU7Z7qO5qB=8Pb=v+1QN0MCy5A@mail.gmail.com> (sfid-20150518_112020_971507_8CA1F646)
References: <chaitanya.mgit@gmail.com>
	 <1431939609-7261-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1431939927.2719.0.camel@sipsolutions.net>
	 <CABPxzYJ-3ctYOdek4RGkt95EKU7Z7qO5qB=8Pb=v+1QN0MCy5A@mail.gmail.com>
	 (sfid-20150518_112020_971507_8CA1F646)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-18 at 14:49 +0530, Krishna Chaitanya wrote:

> My sendmail shows status as bounced so i was trying with different
> options. I did not realize that it has already made it to the list.

It looks like it didn't actually make it to the list *today*, but I
believe there were versions that did. I got 4 of them today though ...

You can always check
https://patchwork.kernel.org/project/linux-wireless/list/

johannes

