Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbZKSRUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 12:20:33 -0500
Subject: Re: mesh endian bugs
From: Dan Williams <dcbw@redhat.com>
To: Rui Paulo <rpaulo@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <7CA4D235-AFC1-4B4A-9025-3A426997706C@gmail.com>
References: <1258638691.7094.16.camel@johannes.local>
	 <7CA4D235-AFC1-4B4A-9025-3A426997706C@gmail.com>
Content-Type: text/plain
Date: Thu, 19 Nov 2009 09:20:20 -0800
Message-Id: <1258651220.32085.25.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-11-19 at 15:50 +0000, Rui Paulo wrote:
> Hi,
> 
> On 19 Nov 2009, at 13:51, Johannes Berg wrote:
> 
> >  CHECK   /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c
> > /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:471:41: warning: incorrect type in argument 4 (different base types)
> > /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:471:41:    expected restricted __le16 [usertype] target_rcode
> > /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:471:41:    got int
> > /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:617:36: warning: incorrect type in argument 4 (different base types)
> > /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:617:36:    expected restricted __le16 [usertype] target_rcode
> > /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:617:36:    got int
> 
> Thanks Johannes. How does one perform this check?

With sparse:

http://lwn.net/Articles/205624/

Dan

