Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60405 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbbEKJwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 05:52:06 -0400
Message-ID: <1431337921.1964.15.camel@sipsolutions.net> (sfid-20150511_115210_912154_EBE83A3A)
Subject: Re: [PATCH] mac80211: IBSS, clear fast_sta when update rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 May 2015 11:52:01 +0200
In-Reply-To: <1431337193-17472-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150511_113957_922464_EF6D0870)
References: <1431337193-17472-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150511_113957_922464_EF6D0870)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-11 at 11:39 +0200, Janusz Dziedzic wrote:
> This is required to handle sta.wme correctly
> after update rates (eg. when using HT/VHT) when
> driver using IEEE80211_HW_SUPPORT_FAST_XMIT.

Wouldn't you want to check, so it can be re-assigned?

johannes

