Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60177 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZDTR03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 13:26:29 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1240248008.4632.10.camel@johannes.local>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 18:26:25 +0100
Message-Id: <1240248385.5260.15.camel@localhost.localdomain> (sfid-20090420_192637_427334_5B50253A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> So far so good
> 
> > wlan0: deauthenticated (Reason: 2)
> 
> This is confusing. And it keeps happening:
> 
> > wlan0: associated
> 
> > wlan0: deauthenticated (Reason: 2)
> 
> > wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=0x431 status=0 aid=2)
> > wlan0: associated
> 
> > wlan0: deauthenticated (Reason: 2)
> 
> > wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=0x431 status=0 aid=2)
> > wlan0: associated
> 
> > wlan0: deauthenticated (Reason: 2)
> 
> > Do you need anything else? I have really no idea what happens here and I
> > like to get it fixed.
> 
> Can you do the kernel log with timing please? It seems strange to get
> "previous authentication is no longer valid" from the AP as a reason
> code while associated.

I can try but I am not home anymore. So no promises. However it keeps
happening in a pretty constant rate. Like every 2-5 seconds interval.

Could be the iwlagn driver for 5350 hardware doing something wrong here.
And I also forced it to use sw_crypto.

Do you have any ideas so far or want me to put some extra debug code in
there. Not sure if I get that kernel up before tomorrow morning.

Regards

Marcel


