Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([207.115.11.53]:34323 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211AbZCXOrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 10:47:20 -0400
Message-ID: <49C8F240.500@lwfinger.net> (sfid-20090324_154743_238636_F98D83E3)
Date: Tue, 24 Mar 2009 09:46:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix RX path
References: <1237880817.6147.26.camel@johannes.local>
In-Reply-To: <1237880817.6147.26.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> My previous patch ("mac80211: remove mixed-cell and userspace MLME code")
> was too obvious to me, so obvious that a stupid bug crept in. The IBSS
> RX function must be invoked for IBSS, of course, not anything != IBSS.
> 
> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

It now works.

Larry
