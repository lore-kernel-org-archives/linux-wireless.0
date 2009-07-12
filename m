Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56745
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbZGLVRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 17:17:33 -0400
Date: Sun, 12 Jul 2009 14:17:37 -0700 (PDT)
Message-Id: <20090712.141737.08152595.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	tgraf@suug.ch, ebiederm@xmission.com
Subject: Re: [PATCH 0/4] generic netlink namespace awareness
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090710195131.504091075@sipsolutions.net>
References: <20090710195131.504091075@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 10 Jul 2009 21:51:31 +0200

> This patch series makes generic netlink network namespace
> aware, in some way, paving the way for making wireless
> completely netns aware (which I will submit to John's tree).
> 
> The required changes are basically some preparations in
> core netlink, a change to make it possible to iterate net
> namespaces under just RCU (which may be useful elsewhere in
> the future), the actual genetlink patch and finally also
> exporting get_net_ns_by_pid() which wireless will need.
> 
> The last patch (for get_net_ns_by_pid) could go through
> the wireless tree as well, but I've put it in here since
> it touches core code. The others probably shouldn't go
> through the wireless tree since they touch more than that.
> 
> The first patch in this series fixes the last remaining
> problem I had with the generic netlink one, the patches
> are actually unchanged from the previous submission other
> than adding patch 1 in front.

Looks good, all applied, thanks!
