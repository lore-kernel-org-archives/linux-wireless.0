Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp116.iad.emailsrvr.com ([207.97.245.116]:60498 "EHLO
	smtp116.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbXBRU5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Feb 2007 15:57:25 -0500
Message-ID: <45D8BDE7.10001@gentoo.org>
Date: Sun, 18 Feb 2007 15:58:15 -0500
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	kune@deine-taler.de
Subject: Re: [PATCH] zd1211rw: changed GFP_NOFS to GFP_KERNEL
References: <20070218202823.9C4A07B409F@zog.reactivated.net>
In-Reply-To: <20070218202823.9C4A07B409F@zog.reactivated.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Drake wrote:
> From: Ulrich Kunitz <kune@deine-taler.de>
> 
> Michael Buesch commented that GFP_NOFS should not be used in a
> network driver. This patch implements it for zd1211rw-d80211.

Forgot to update the description. As you might have figured, this 
version of the patch is for wireless-2.6, and the earlier one was for
wireless-dev.

Daniel
