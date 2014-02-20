Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32563 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaBTJt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 04:49:57 -0500
Date: Thu, 20 Feb 2014 11:49:52 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <c_ppotte@qti.qualcomm.com>,
	<djindal@qti.qualcomm.com>
Subject: Re: [PATCH] cfg80211: Pass TDLS peer capability information in
 tdls_mgmt
Message-ID: <20140220094952.GA6290@jouni.qca.qualcomm.com> (sfid-20140220_105003_124456_8ED32B70)
References: <1392822952-17690-1-git-send-email-usdutt@qti.qualcomm.com>
 <1392889161.5073.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1392889161.5073.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 20, 2014 at 10:39:21AM +0100, Johannes Berg wrote:
> Generally, the patch looks fine, but I think you need to modify mac80211
> as well, and the mwifiex patch doesn't apply to my mac80211-next tree.

How do you want to handle mwifiex then? That function is in
wireless-testing.git and if the cfg80211 API change goes through
mac80211-next that does not have mwifiex change, I'd assume the build
will break once that gets merged into wireless-testing (or whatever is
the first tree getting changes from both)?

-- 
Jouni Malinen                                            PGP id EFC895FA
