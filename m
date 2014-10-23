Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57202 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710AbaJWSmq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 14:42:46 -0400
Message-ID: <1414089763.29820.2.camel@jlt4.sipsolutions.net> (sfid-20141023_204249_236357_42DE11BF)
Subject: Re: [PATCH] mac80211: fix network header breakage during encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Thu, 23 Oct 2014 20:42:43 +0200
In-Reply-To: <1413970425-5829-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1413970425-5829-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-22 at 12:33 +0300, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> When an IV is generated, only the MAC header is moved back. The network
> header location remains the same relative to the skb head, as the new IV
> is using headroom space that was reserved in advance.

Applied.

johannes

