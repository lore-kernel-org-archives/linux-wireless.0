Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:41960 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaKKJyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 04:54:21 -0500
Message-ID: <5461DCC9.5050702@broadcom.com> (sfid-20141111_105449_986104_5AC9242E)
Date: Tue, 11 Nov 2014 10:54:17 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"Gautam (Gautam Kumar) Shukla" <gautams@broadcom.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Jithu Jance <jithu@broadcom.com>,
	Sreenath S <sreenats@broadcom.com>
Subject: Re: [PATCH 1/1] linux-wireless: Added psk in struct cfg80211_connect_params
 needed for offloading 4way handshake to driver
References: <DF163EE1A432BF4BBE6B2088220663A67437BD@SJEXCHMB06.corp.ad.broadcom.com> <1415698161.2163.0.camel@sipsolutions.net>
In-Reply-To: <1415698161.2163.0.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-11-14 10:29, Johannes Berg wrote:
> On Tue, 2014-11-11 at 05:56 +0000, Gautam (Gautam Kumar) Shukla wrote:
>> For offloading 4 way handshake to driver, currently we don't have any
>> member  of struct cfg80211_connect_params to pass PSK from supplicant
>> to driver. I have added psk for the same and added rest of the code
>> needed in nl80211.h and nl80211.c to parse and make it available to
>> driver.
>> From supplicant, we already have psk member field in assoc_params to
>> use .
>>
>> Tested on x86 linux.
> 
> Your commit message needs serious work.
> 
> Also, there's a competing approach from QCA that's far more suited.

I probably was not paying attention to it, but would you have a
reference to this.

> In either case though, I'm going to ask which driver is going to use
> this and when it's going to land in mainline.

I had the same question ;-)

> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

