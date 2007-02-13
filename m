Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54441
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030571AbXBMAPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 19:15:42 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/4] create cfg80211
Date: Tue, 13 Feb 2007 01:15:31 +0100
Cc: linux-wireless@vger.kernel.org,
	Broadcom Linux <bcm43xx-dev@berlios.de>
References: <20070209162711.375886000@sipsolutions.net> <1171222767.3576.2.camel@johannes.berg> <1171267928.4881.9.camel@johannes.berg>
In-Reply-To: <1171267928.4881.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200702130115.32118.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 February 2007 09:12, Johannes Berg wrote:
> The real bug I'm chasing (use-after-free leading to oops when rmmod'ing
> bcm43xx-d80211 while device is up) is in bcm43xx-d80211 and I found it
> too. Consider the following changes I made to debug:

Should be fixed in my tree now.
Thanks for the good bugreport.

-- 
Greetings Michael.
