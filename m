Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45647 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbbC3Inq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:43:46 -0400
Message-ID: <1427705012.26117.11.camel@sipsolutions.net> (sfid-20150330_104354_387395_1EAE95F1)
Subject: Re: [PATCH] mac80211: fix failed to set smps
From: Johannes Berg <johannes@sipsolutions.net>
To: miaoqing@qti.qualcomm.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com
Date: Mon, 30 Mar 2015 10:43:32 +0200
In-Reply-To: <1427433674-5745-1-git-send-email-miaoqing@qca.qualcomm.com> (sfid-20150327_062125_551844_AE1F0CE9)
References: <1427433674-5745-1-git-send-email-miaoqing@qca.qualcomm.com>
	 (sfid-20150327_062125_551844_AE1F0CE9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-03-27 at 13:21 +0800, miaoqing@qti.qualcomm.com wrote:
> From: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> 
> Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>

Since you give no commit log, I can only guess what you're trying to do,
but I suppose you need to use "echo -n" instead of "echo".

johannes

