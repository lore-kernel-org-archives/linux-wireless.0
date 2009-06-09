Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2983 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760242AbZFIOxl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 10:53:41 -0400
Subject: Re: [PATCH] mac80211: don't use master netdev name
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1244558970.4672.26.camel@johannes.local>
References: <1244557112.4672.20.camel@johannes.local>
	 <1244558869.895.7.camel@mj>  <1244558970.4672.26.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 10:53:42 -0400
Message-Id: <1244559222.895.8.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-06-09 at 16:49 +0200, Johannes Berg wrote:
> > I wish we could hide those master devices using some "hidden network
> > device" attribute, but it's not happening.
> 
> Actually, the reason I'm posting this patch is that I'm killing the
> mdev.

:-)
Excellent!

-- 
Regards,
Pavel Roskin
