Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:15231 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbZKSPuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 10:50:09 -0500
Received: by ey-out-2122.google.com with SMTP id 4so44645eyf.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2009 07:50:14 -0800 (PST)
Subject: Re: mesh endian bugs
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Rui Paulo <rpaulo@gmail.com>
In-Reply-To: <1258638691.7094.16.camel@johannes.local>
Date: Thu, 19 Nov 2009 15:50:10 +0000
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <7CA4D235-AFC1-4B4A-9025-3A426997706C@gmail.com>
References: <1258638691.7094.16.camel@johannes.local>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 19 Nov 2009, at 13:51, Johannes Berg wrote:

>  CHECK   /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c
> /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:471:41: warning: incorrect type in argument 4 (different base types)
> /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:471:41:    expected restricted __le16 [usertype] target_rcode
> /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:471:41:    got int
> /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:617:36: warning: incorrect type in argument 4 (different base types)
> /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:617:36:    expected restricted __le16 [usertype] target_rcode
> /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:617:36:    got int

Thanks Johannes. How does one perform this check?

--
Rui Paulo

