Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:56419 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab3JKTmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:39 -0400
Received: by mail-oa0-f43.google.com with SMTP id i3so2781192oag.16
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 12:42:38 -0700 (PDT)
Message-ID: <525854AD.5020607@lwfinger.net> (sfid-20131011_214249_125375_3733B587)
Date: Fri, 11 Oct 2013 14:42:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in commit 0d528d8
References: <52571723.5020000@lwfinger.net> <52571DAA.60502@openwrt.org>
In-Reply-To: <52571DAA.60502@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/2013 04:35 PM, Felix Fietkau wrote:
> I don't recall any necessary extra actions introduced by this patch.
> Please compare the rate selection info passed to the driver before and
> after this patch, by dumping info->control.rates.

I dumped the structure returned by ieee80211_get_tx_rate(hw, info) and found the 
same values for the case that worked and the one that failed. The values were: 
flags 0xc, bitrate 0xa, hw_value 0x0, and hw_value_short 0x0.

Larry



