Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37399 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbbBXIFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 03:05:52 -0500
Message-ID: <1424765148.2192.1.camel@sipsolutions.net> (sfid-20150224_090555_777852_57598D47)
Subject: Re: [PATCH 1/2] cfg80211: Allow NL80211_ATTR_IFINDEX to be added to
 vendor events
From: Johannes Berg <johannes@sipsolutions.net>
To: "Kholaif, Ahmad" <akholaif@qca.qualcomm.com>
Cc: "Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>
Date: Tue, 24 Feb 2015 09:05:48 +0100
In-Reply-To: <656e25eaa73746acb1108bd0943e502e@nalasexr02a.na.qualcomm.com>
References: <1424442925-10778-1-git-send-email-jouni@qca.qualcomm.com>
	 <1424705846.3075.3.camel@sipsolutions.net>
	 <656e25eaa73746acb1108bd0943e502e@nalasexr02a.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This means that this kernel change can't be pulled in without
> corresponding driver changes to call  cfg80211_vendor_event_alloc()
> with a NULL for wdev. Please confirm if this is acceptable; otherwise,
> we would need to use the new wrapper defined above.

This is fine to me, there are very few such users anyway (make sure to
update in a single patch.)

johannes

