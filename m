Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45858 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbbK0KUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 05:20:37 -0500
Message-ID: <1448619634.2531.38.camel@sipsolutions.net> (sfid-20151127_112040_885840_3E40CA9A)
Subject: Re: [PATCH] mac80211_hwsim: Advertise support for VHT IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Nov 2015 11:20:34 +0100
In-Reply-To: <20151126185104.GA27594@w1.fi>
References: <20151126185104.GA27594@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-26 at 20:51 +0200, Jouni Malinen wrote:
> VHT can be used with IBSS without needing any additional changes in
> mac80211_hwsim, so start claiming support for this to increase test
> coverage.
> 

Applied all the three, thanks.

johannes
