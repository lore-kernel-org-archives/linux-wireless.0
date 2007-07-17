Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:55382 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934173AbXGQP30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2007 11:29:26 -0400
Message-ID: <469CE051.5060805@lwfinger.net>
Date: Tue, 17 Jul 2007 10:29:21 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: patches ping
References: <1184674109.3773.70.camel@johannes.berg>
In-Reply-To: <1184674109.3773.70.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> What happened to my patches
> 
>  * mac80211: regdomain.c needs to include ieee80211_i.h
>  * mac80211: kill PRISM2_HOSTAPD_UPDATE_IF sub-ioctl
>  * mac80211: move wpa trigger to debugfs
>  * mac80211: kill PRISM2_PARAM_AP_AUTH_ALGS

Add to Johannes's list

[PATCH V3] mac80211: Implementation of SIOCSIWRATE

Larry
