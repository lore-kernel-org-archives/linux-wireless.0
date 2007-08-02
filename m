Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58629 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbXHBVEn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 17:04:43 -0400
Subject: Re: [RFC 0/10] Port of bcm43xx from softmac to mac80211
From: David Woodhouse <dwmw2@infradead.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, jbenc@suse.cz,
	flamingice@sourmilk.net
In-Reply-To: <46B20695.2080100@lwfinger.net>
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net>
	 <200708021807.20649.mb@bu3sch.de>  <46B20695.2080100@lwfinger.net>
Content-Type: text/plain
Date: Thu, 02 Aug 2007 22:04:38 +0100
Message-Id: <1186088678.2931.10.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-08-02 at 11:30 -0500, Larry Finger wrote:
> I was hoping this would be your response, but I had to make the
> effort. I'll wait for a couple of days to see if anyone else has any
> comments and send it on to Linville and hope it ends up in -mm  fairly
> soon. It _DOES_ work on the hardware.

My experience is that mac80211 is broken w.r.t IPv6 -- it receives its
own packets. It would be suboptimal for me if the softmac version of
bcm43xx were to go away before that got fixed.

-- 
dwmw2

