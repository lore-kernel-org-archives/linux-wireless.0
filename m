Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:26642 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbYFLSeI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 14:34:08 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2138845rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 11:34:05 -0700 (PDT)
Subject: Re: [RFC] Do not activate promiscuous mode on wlan interfaces for
	bridging.
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, shemminger@linux-foundation.org,
	j@w1.fi, bridge@linux-foundation.org,
	Linux Netdev List <netdev@vger.kernel.org>
In-Reply-To: <1213294852.3730.31.camel@johannes.berg>
References: <1213232760.6645.24.camel@localhost>
	 (sfid-20080612_030607_332834_1EFDE126)  <1213255570.3871.8.camel@johannes.berg>
	 <1213294793.6615.16.camel@localhost>
	 (sfid-20080612_202000_504292_98E93460)  <1213294852.3730.31.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 11:34:03 -0700
Message-Id: <1213295643.6615.20.camel@localhost> (sfid-20080612_203412_422394_9C5FB4BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-12 at 20:20 +0200, Johannes Berg wrote:
> Is this a mac80211 driver? When are you activating promisc?

Yes, libertastf (adaptation of the libertas driver to use a thin
firmware and mac80211), you can check it out at 

git://dev.laptop.org/users/javier/libertastf.git

Still want to polish it a bit before submitting.

Promiscuous mode is being activated when attaching the interface to a
bridge, in the lines included in the patch on the first mail in the
thread.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


