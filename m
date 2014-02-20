Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60130 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaBTJj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 04:39:27 -0500
Message-ID: <1392889161.5073.15.camel@jlt4.sipsolutions.net> (sfid-20140220_103930_794452_A9A27F0F)
Subject: Re: [PATCH] cfg80211: Pass TDLS peer capability information in
 tdls_mgmt
From: Johannes Berg <johannes@sipsolutions.net>
To: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	c_ppotte@qti.qualcomm.com, djindal@qti.qualcomm.com
Date: Thu, 20 Feb 2014 10:39:21 +0100
In-Reply-To: <1392822952-17690-1-git-send-email-usdutt@qti.qualcomm.com> (sfid-20140219_161608_023983_BEACD75F)
References: <1392822952-17690-1-git-send-email-usdutt@qti.qualcomm.com>
	 (sfid-20140219_161608_023983_BEACD75F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generally, the patch looks fine, but I think you need to modify mac80211
as well, and the mwifiex patch doesn't apply to my mac80211-next tree.

johannes

