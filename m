Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:40402 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbYFLSxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 14:53:37 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2147587rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 11:53:37 -0700 (PDT)
Subject: Re: [RFC] Do not activate promiscuous mode on wlan interfaces for
	bridging.
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, shemminger@linux-foundation.org,
	j@w1.fi, bridge@linux-foundation.org,
	Linux Netdev List <netdev@vger.kernel.org>
In-Reply-To: <1213296250.3730.33.camel@johannes.berg>
References: <1213232760.6645.24.camel@localhost>
	 (sfid-20080612_030607_332834_1EFDE126)  <1213255570.3871.8.camel@johannes.berg>
	 <1213294793.6615.16.camel@localhost>
	 (sfid-20080612_202000_504292_98E93460)  <1213294852.3730.31.camel@johannes.berg>
	 <1213295643.6615.20.camel@localhost>
	 (sfid-20080612_203408_119945_EA437275)  <1213296250.3730.33.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 11:53:35 -0700
Message-Id: <1213296815.6615.24.camel@localhost> (sfid-20080612_205341_245044_06EEF8B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-12 at 20:44 +0200, Johannes Berg wrote:
> But in response to what mac80211 command are you sending the promisc
> mode to the hw?

In the function associated to .configure_filter (struct ieee80211_ops)
in the driver, when (*new_flags & (FIF_PROMISC_IN_BSS))

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


