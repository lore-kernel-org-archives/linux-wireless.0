Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab2JKRpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 13:45:32 -0400
Message-ID: <1349977564.13097.14.camel@jlt4.sipsolutions.net> (sfid-20121011_194536_624967_9E8E2408)
Subject: Re: [RFC] wireless: cfg80211: add peer-to-peer related definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Oct 2012 19:46:04 +0200
In-Reply-To: <507701E3.8060001@broadcom.com>
References: <1349965104-14475-1-git-send-email-arend@broadcom.com>
	 <1349973736.13097.12.camel@jlt4.sipsolutions.net>
	 <507700DF.80401@broadcom.com> <507701E3.8060001@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-11 at 19:29 +0200, Arend van Spriel wrote:

> >>> +/* Vendor-specific IE */
> >>> +#define IEEE80211_VENDOR_SPEC_IE        0xDD
> >>
> >> actually this already exists, as ..._EID_VENDOR or so?

> Found it. I can even choose:
> 
> /* Information Element IDs */
> enum ieee80211_eid {
> 	:
> 	WLAN_EID_WPA = 221,
> 	WLAN_EID_GENERIC = 221,
> 	WLAN_EID_VENDOR_SPECIFIC = 221,

Heh, funny. Different context and age, I guess.

johannes

