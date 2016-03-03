Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56437 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbcCCPLc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:11:32 -0500
Message-ID: <1457017889.2044.18.camel@sipsolutions.net> (sfid-20160303_161136_409173_E7E8C936)
Subject: Re: [PATCH v2 1/3] cfg80211: Allow a scan request for a specific
 BSSID
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 Mar 2016 16:11:29 +0100
In-Reply-To: <1456517569-27235-1-git-send-email-jouni@qca.qualcomm.com>
References: <1456517569-27235-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-02-26 at 22:12 +0200, Jouni Malinen wrote:
> This allows scans for a specific BSSID to be optimized by the user
> space
> application by requesting the driver to set the Probe Request frame
> BSSID field (Address 3) to the specified BSSID instead of the
> wildcard
> BSSID. This prevents other APs from replying which reduces airtime
> need
> and latency in getting the response from the target AP through.
> 
> This is an optimization and as such, it is acceptable for some of the
> drivers not to support the mechanism. If not supported, the wildcard
> BSSID will be used and more responses may be received.
> 
Applied all three.

johannes
