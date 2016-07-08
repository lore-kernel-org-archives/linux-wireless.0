Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54380 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbcGHKeo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 06:34:44 -0400
Message-ID: <1467974081.4837.5.camel@sipsolutions.net> (sfid-20160708_123446_820437_AB543E51)
Subject: Re: [PATCH] cfg80211: Allow different beacon interval support on
 virtual interface.
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
Date: Fri, 08 Jul 2016 12:34:41 +0200
In-Reply-To: <1467973935-32308-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160708_123302_163593_694AA25F)
References: <1467973935-32308-1-git-send-email-pkushwah@qti.qualcomm.com>
	 (sfid-20160708_123302_163593_694AA25F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-07-08 at 16:02 +0530, Purushottam Kushwaha wrote:
> Driver may support different beacon interval on virtual interfaces.
> Allow setting different beacon interval per interface if driver has
> such support.
> 
It seems this should be an nl80211 feature flag (ext features)

johannes
