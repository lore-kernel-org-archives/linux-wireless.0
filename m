Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58442 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbYLSOfc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 09:35:32 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 06:35:32 -0800
Message-ID: <494BB0BE.3030705@atheros.com> (sfid-20081219_153543_971511_4EBFDB75)
Date: Fri, 19 Dec 2008 20:03:34 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] [RFC] mac80211: Disable HT negotiation with TKIP/WEP
 as pairwise cipher
References: <1229692235-21734-1-git-send-email-vasanth@atheros.com> <20081219142822.GA4041@tuxdriver.com>
In-Reply-To: <20081219142822.GA4041@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Fri, Dec 19, 2008 at 06:40:35PM +0530, Vasanthakumar Thiagarajan wrote:
>> IEEE802.11n does not allow TKIP/WEP as pairwise cipher in HT mode.
>> Connect in non-ht mode if either of these ciphers is cofigured as
>> pairwise.
>>
>> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> 
> Are there perhaps any broken APs out there that support such a
> configuration?  I would hate to prevent users from connecting simply
> out of blind obedience to the standard.

This particular configuration is not allowed in the latest 11n draft (7.0).
Yes, we have quite a few AP's around which support this configuration. 


Vasanth
