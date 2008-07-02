Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:52325 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbYGBTPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 15:15:21 -0400
Message-ID: <486BD41D.4010300@lwfinger.net> (sfid-20080702_211524_974722_59FE7420)
Date: Wed, 02 Jul 2008 14:16:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] mac80211: remove ieee80211_get_hdr_info
References: <1215021935.24353.16.camel@brick>
In-Reply-To: <1215021935.24353.16.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Harvey Harrison wrote:
> Do the check for sufficient skb->len explicitly and pass a pointer
> to the struct ieee80211_hdr directly to the michael_mic calculation.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Larry, please test as I believe I fixed the bug in the previous version of
> this patch...see michael_mic_hdr() for the is_data_qos check I missed last
> time.

This version works with WPA-PSK TKIP.

Larry
