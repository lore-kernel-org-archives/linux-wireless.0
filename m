Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35063 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928AbbKDQT4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 11:19:56 -0500
Message-ID: <1446653993.17416.3.camel@sipsolutions.net> (sfid-20151104_172009_306535_8608499F)
Subject: Re: [PATCH 3/4] ipv4: add option to drop gratuitous ARP packets
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Anastasov <ja@ssi.bg>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	matti.gottlieb@intel.com
Date: Wed, 04 Nov 2015 17:19:53 +0100
In-Reply-To: <alpine.LFD.2.11.1504111340170.2449@ja.home.ssi.bg>
References: <1428652454-1224-1-git-send-email-johannes@sipsolutions.net>
	 <1428652454-1224-3-git-send-email-johannes@sipsolutions.net>
	 <alpine.LFD.2.11.1504111340170.2449@ja.home.ssi.bg>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-04-11 at 13:59 +0300, Julian Anastasov wrote:
> 
>         May be only arptable_filter can help here to
> protect ARP?
> 

Finally reviving an ancient thread ...

I checked, butI don't see a way to match tip==sip. You can match on
each, but not against each other.

johannes
