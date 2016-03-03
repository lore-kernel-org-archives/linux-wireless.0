Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56122 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbcCCO3j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 09:29:39 -0500
Message-ID: <1457015372.2044.6.camel@sipsolutions.net> (sfid-20160303_152955_323285_A43DD1CD)
Subject: Re: [PATCHv2] mac80211: parse VHT info in injected frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 03 Mar 2016 15:29:32 +0100
In-Reply-To: <1456238615-832-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20160223_154337_574755_E9ED15D4)
References: <1456238615-832-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20160223_154337_574755_E9ED15D4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-23 at 15:43 +0100, Lorenzo Bianconi wrote:
> Add VHT radiotap parsing support to ieee80211_parse_tx_radiotap().
> That capability has been tested using a d-link dir-860l rev b1
> running OpenWrt trunk and mt76 driver
> 
Applied. In case you didn't see, Sven sent a patch to fix the other
docs.

johannes
