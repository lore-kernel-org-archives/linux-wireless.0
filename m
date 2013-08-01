Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3HAHcp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 03:32:45 -0400
Message-ID: <1375342361.8608.2.camel@jlt4.sipsolutions.net> (sfid-20130801_093250_588058_393D5CC5)
Subject: Re: [PATCH] ieee80211: add definition for interworking support
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org, Avinash Patil <patila@marvell.com>
Date: Thu, 01 Aug 2013 09:32:41 +0200
In-Reply-To: <1374883349-22912-1-git-send-email-bzhao@marvell.com>
References: <1374883349-22912-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-26 at 17:02 -0700, Bing Zhao wrote:
> From: Avinash Patil <patila@marvell.com>
> 
> IEEE802.11u interworking support is advertised via extended
> capabilities IE bit 31. This is 7th bit of 4th byte of extended
> capabilities.

I've applied this, but why is this needed in the kernel? Isn't the
supplicant managing the interworking stuff?

johannes

