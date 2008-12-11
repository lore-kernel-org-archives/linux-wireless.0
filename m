Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23107.mail.ird.yahoo.com ([217.146.189.47]:34804 "HELO
	web23107.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751027AbYLKMRO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 07:17:14 -0500
Date: Thu, 11 Dec 2008 12:17:12 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Fix for change in STA handling in mac80211
To: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <49407404.WzMzB28hDBCaCLlQ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <127576.99770.qm@web23107.mail.ird.yahoo.com> (sfid-20081211_131718_130859_F58D9E71)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Thu, 11/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Larry Finger <Larry.Finger@lwfinger.net>
<snipped>
> After commit ca247d5f50acd4fc6fdc1dec770e726b0d7eda60
> "mac80211: only create
> default STA interface if supported", rtl8187 stopped
> working because the
> add_interface callback was not called. For reasons that I
> do not understand,
> the IFTYPE_ADHOC bit, as well as the IFTYPE_STATION bit,
> must be set in the
> interface_modes variable.
> 
> Signed-off-by: Larry Finger
> <Larry.Finger@lwfinger.net>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Okay, the disappeared wlan* device is back.

> John,
> 
> This should be added to wireless-testing as soon as
> possible.

I don't know the verdict yet - but I think we need to either revert Johannes's earlier patch, or have this change from Larry incoporated, ASAP.

Hin-Tak


      
