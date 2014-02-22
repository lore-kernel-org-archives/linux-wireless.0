Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:40791 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaBVRT7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 12:19:59 -0500
Message-ID: <5308DC3E.8000501@lwfinger.net> (sfid-20140222_182022_780179_4C139D68)
Date: Sat, 22 Feb 2014 11:19:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] rtlwifi: Convert drivers to use new API for ieee80211_is_robust_mgmt_frame()
References: <1393089433-28270-1-git-send-email-Larry.Finger@lwfinger.net> <1393089433-28270-18-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1393089433-28270-18-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/22/2014 11:17 AM, Larry Finger wrote:
> Drivers rtl8188ee, rtl8192ce, rtl8192se, and rtl8723ae all use this routine.
> In addition, all callers of ieee80211_is_robust_mgmt_frame() have access to the
> skb. Thus, it is trivial to use the new API rather than the underscored old version.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> ---

John and Johannes,

Ignore this one. It was sent by mistake.

Larry


