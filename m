Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39603 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933597AbcAZNKb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 08:10:31 -0500
Message-ID: <1453813828.2759.42.camel@sipsolutions.net> (sfid-20160126_141053_435643_0DAC2A7A)
Subject: Re: [PATCH] net:mac80211:mesh_plink: remove redundant sta_info check
From: Johannes Berg <johannes@sipsolutions.net>
To: Sunil Shahu <shshahu@gmail.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 26 Jan 2016 14:10:28 +0100
In-Reply-To: <1453354585-26069-1-git-send-email-shshahu@gmail.com> (sfid-20160121_063642_266180_2ACB780C)
References: <1453354585-26069-1-git-send-email-shshahu@gmail.com>
	 (sfid-20160121_063642_266180_2ACB780C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-01-21 at 11:06 +0530, Sunil Shahu wrote:
> Remove unnecessory "if" statement and club it with previos "if"
> block.
> 
Applied.

johannes
