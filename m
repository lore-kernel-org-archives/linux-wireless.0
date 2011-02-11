Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab1BKKXo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 05:23:44 -0500
Date: Fri, 11 Feb 2011 11:22:14 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>
Cc: "'Johannes Berg'" <johannes@sipsolutions.net>,
	"'Larry Finger'" <Larry.Finger@lwfinger.net>,
	"'John W Linville'" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	=?utf-8?B?J+WGr+aYpeeHlSc=?= <amyfcy_feng@realsil.com.cn>,
	=?utf-8?B?J+eGiuWFieWuiSc=?= <guangan_xiong@realsil.com.cn>
Subject: Re: [RFC] mac80211: cisco 1252 HT bw20, sta->ht_cap.cap bw is wrong
Message-ID: <20110211102213.GA2231@redhat.com>
References: <20110207151209.GG2319@redhat.com>
 <B84A4806C46340989E2A6AD2EB663300@realsil.com.cn>
 <20110209105405.GB5528@redhat.com>
 <B8DE8263FD784AC082CFDB7E9269BAEA@realsil.com.cn>
 <20110210074140.GA2228@redhat.com>
 <39A39FA0AD1A481480DE0BD469AAA79E@realsil.com.cn>
 <20110210095006.GB2228@redhat.com>
 <86D43C3FD69641C38E7144E721BCC5A6@realsil.com.cn>
 <20110210113715.GA31839@redhat.com>
 <3734EB1DAE3E49A1867FDE1C680A296D@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <3734EB1DAE3E49A1867FDE1C680A296D@realsil.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 11, 2011 at 10:26:13AM +0800, 李朝明 wrote:
> Dear Stanislaw:
"Hi" would be enough ;-)

> 	I find for cisco 1252 11N mode bandwith-20,
> ieee80211_sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40
> 	was wrong in bss_info_changed, I have to check 20/40 MHZ based on
> hw->conf.channel_type.
> 
> 	All other APs will be ok, So may be it's AP IE's issue, But I think
> mac80211 should also check hw->conf.channel_type
> 	before set ieee80211_sta->ht_cap.cap &
> IEEE80211_HT_CAP_SUP_WIDTH_20_40.
Perhaps you could send patch with fix?

Stanislaw
