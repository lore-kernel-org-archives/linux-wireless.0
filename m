Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54857 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbbFIUEz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 16:04:55 -0400
Message-ID: <1433880292.1892.21.camel@sipsolutions.net> (sfid-20150609_220459_717595_1027BF9B)
Subject: Re: [PATCH] mac80211: fix the beacon csa counter for mesh and ibss
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Tue, 09 Jun 2015 22:04:52 +0200
In-Reply-To: <1433828133-6904-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150609_073553_694972_738061F4)
References: <1433828133-6904-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20150609_073553_694972_738061F4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-09 at 13:35 +0800, Chun-Yeow Yeoh wrote:
> The csa counter has moved from sdata to beacon/presp but
> it is not updated accordingly for mesh and ibss. Fix this.
> 
> This regression is introduced by the following patch:
> mac80211: move csa counters from sdata to beacon/presp

Applied.

johannes

