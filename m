Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40122 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbcGFLvw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 07:51:52 -0400
Message-ID: <1467805908.26633.1.camel@sipsolutions.net> (sfid-20160706_135155_784008_6309ACA8)
Subject: Re: [PATCH 3/7] cfg80211: handle failed skb allocation
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 06 Jul 2016 13:51:48 +0200
In-Reply-To: <1467721394-8195-4-git-send-email-luca@coelho.fi>
References: <1467721394-8195-1-git-send-email-luca@coelho.fi>
	 <1467721394-8195-4-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-07-05 at 15:23 +0300, Luca Coelho wrote:
> From: Gregory Greenman <gregory.greenman@intel.com>
> 
> Handle the case when dev_alloc_skb returns NULL.
> 
Applied. A Fixes: tag would have been nice, but I added one :)

johannes
