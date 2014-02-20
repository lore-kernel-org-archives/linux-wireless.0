Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaBTJ4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 04:56:39 -0500
Message-ID: <1392890196.5073.20.camel@jlt4.sipsolutions.net> (sfid-20140220_105644_736051_2F90A199)
Subject: Re: [PATCH] cfg80211: Pass TDLS peer capability information in
 tdls_mgmt
From: Johannes Berg <johannes@sipsolutions.net>
To: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	c_ppotte@qti.qualcomm.com, djindal@qti.qualcomm.com
Date: Thu, 20 Feb 2014 10:56:36 +0100
In-Reply-To: <1392889161.5073.15.camel@jlt4.sipsolutions.net> (sfid-20140220_103930_794452_A9A27F0F)
References: <1392822952-17690-1-git-send-email-usdutt@qti.qualcomm.com>
	 (sfid-20140219_161608_023983_BEACD75F) <1392889161.5073.15.camel@jlt4.sipsolutions.net>
	 (sfid-20140220_103930_794452_A9A27F0F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 10:39 +0100, Johannes Berg wrote:
> Generally, the patch looks fine, but I think you need to modify mac80211
> as well, and the mwifiex patch doesn't apply to my mac80211-next tree.

Also

$ git am -s /tmp/\[PATCH\]_cfg80211
\:_Pass_TDLS_peer_capability_information_in_tdls_mgmt.mbox
Applying: cfg80211: Pass TDLS peer capability information in tdls_mgmt
/home/johannes/sys/wireless/.git/rebase-apply/patch:70: trailing
whitespace.
 * to be added to TDLS Setup frames. 
warning: 1 line adds whitespace errors.



