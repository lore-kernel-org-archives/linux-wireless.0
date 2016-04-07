Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43733 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbcDGI4i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 04:56:38 -0400
Message-ID: <1460019395.27154.7.camel@sipsolutions.net> (sfid-20160407_105641_856504_0205ABCF)
Subject: Re: [PATCH] cfg80211: Improve Connect/Associate command
 documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 07 Apr 2016 10:56:35 +0200
In-Reply-To: <1459953524-12590-1-git-send-email-jouni@qca.qualcomm.com>
References: <1459953524-12590-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-04-06 at 17:38 +0300, Jouni Malinen wrote:
> The roaming cases for the Connect command were not fully covered and
> neither Connect nor Associate command uses of the prev_bssid
> parameter
> were very clear. Add details to describe how the prev_bssid argument
> is
> supposed to be used and when the driver should use association or
> reassociation.
> 
Applied, thanks.

johannes
