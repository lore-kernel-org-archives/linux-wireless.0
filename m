Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp136.iad.emailsrvr.com ([207.97.245.136]:41894 "EHLO
	smtp136.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbXHBWbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 18:31:55 -0400
Message-ID: <46B25B04.5020804@gentoo.org>
Date: Thu, 02 Aug 2007 18:30:28 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Larry Finger <larry.finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, jbenc@suse.cz,
	flamingice@sourmilk.net
Subject: mac80211 IPv6 problems
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net>	 <200708021807.20649.mb@bu3sch.de>  <46B20695.2080100@lwfinger.net> <1186088678.2931.10.camel@pmac.infradead.org>
In-Reply-To: <1186088678.2931.10.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse wrote:
> My experience is that mac80211 is broken w.r.t IPv6 -- it receives its
> own packets. It would be suboptimal for me if the softmac version of
> bcm43xx were to go away before that got fixed.

This may be a stack-level issue. This is one of the issues holding back 
zd1211rw-mac80211 going into mainline: we have a report that 
zd1211rw-softmac works fine with IPv6 but mac80211 only works 
occasionally with the same device on the same system.

Does anyone have any ideas?

Thanks,
Daniel
