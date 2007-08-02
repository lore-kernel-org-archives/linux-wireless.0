Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34454
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbXHBWgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 18:36:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: mac80211 IPv6 problems
Date: Fri, 3 Aug 2007 00:36:12 +0200
Cc: David Woodhouse <dwmw2@infradead.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	jbenc@suse.cz, flamingice@sourmilk.net
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net> <1186088678.2931.10.camel@pmac.infradead.org> <46B25B04.5020804@gentoo.org>
In-Reply-To: <46B25B04.5020804@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708030036.13317.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 August 2007, Daniel Drake wrote:
> David Woodhouse wrote:
> > My experience is that mac80211 is broken w.r.t IPv6 -- it receives its
> > own packets. It would be suboptimal for me if the softmac version of
> > bcm43xx were to go away before that got fixed.
> 
> This may be a stack-level issue. This is one of the issues holding back 
> zd1211rw-mac80211 going into mainline: we have a report that 
> zd1211rw-softmac works fine with IPv6 but mac80211 only works 
> occasionally with the same device on the same system.
> 
> Does anyone have any ideas?

This is certainly an issue in the packet filtering of mac80211.

