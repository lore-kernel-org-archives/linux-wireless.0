Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:60378 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZF1OHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Jun 2009 10:07:16 -0400
Received: by ewy6 with SMTP id 6so4844329ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 28 Jun 2009 07:07:18 -0700 (PDT)
Message-ID: <4A47790F.7030401@gmail.com>
Date: Sun, 28 Jun 2009 15:07:11 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Balaji Ravindran <b@w1an.in>,
	Mircea Gherzan <mgherzan@gmail.com>
Subject: Re: Proposal enquiry for Wireless Roaming feature enhancement
References: <4A38672F.9090904@w1an.in> <1245681796.4338.24.camel@dhcp-100-3-98.bos.redhat.com> <87k534nwy3.fsf@litku.valot.fi> <200906231001.29728.hs4233@mail.mn-solutions.de>
In-Reply-To: <200906231001.29728.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig wrote:
>> Can you tell anything about the configuration parameters
>> available? For example, can the driver configure an rssi
>> threshold for enabling background scanning[1]?
> 
> Orinoco and WLAGS Hermes1 and Hermes2 has some "sensitivy" 
> setting, from 1..3:
> 
> $ iwconfig eth1 sens 3
> 
> What exactly this does is a bit opaque and handled by the 
> firmware.

I wasn't paying too much attention to this thread. However as part of a
separate thread* I had a look into orinoco's sensitivity setting.

Anyway, see my e-mail earlier today for a description of what the values
do. The description should be valid for Intersil and Agere firmware
(including most if not all old versions), and applies to orinoco and
WL_LKM drivers.


Regards,

Dave.

* the thread is titled "[RFC 00/11] cfg80211: connect API + wireless
extension move"
