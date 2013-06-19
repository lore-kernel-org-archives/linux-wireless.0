Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1818 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935060Ab3FSU6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 16:58:51 -0400
Message-ID: <51C21B7C.2030005@broadcom.com> (sfid-20130619_225855_636923_C45609DE)
Date: Wed, 19 Jun 2013 22:58:36 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Chris Adams" <cma@cmadams.net>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BCM4331 deauthenticates every five minutes
References: <20130619160911.GB4784@cmadams.net>
 <51C1DDEB.3090701@lwfinger.net> <20130619164227.GC4784@cmadams.net>
 <CACna6rzbTHnyqs5SzTuYL7r_SW3iCNh0qqbnvfsF7Wspyhp1WA@mail.gmail.com>
 <20130619175850.GD4784@cmadams.net>
In-Reply-To: <20130619175850.GD4784@cmadams.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2013 07:58 PM, Chris Adams wrote:
> Once upon a time, Rafał Miłecki <zajec5@gmail.com> said:
>> I don't know how/if driver can be responsible for such reconnects.
>> Over all it just TX and RX packets, right? Loosing a signal is
>> something different, that can be related to the driver's bug. But as
>> this happens every 5 minutes... I don't know.
>>
>> Did you try connecting to this AP with any other card and using
>> similar kernel? I wonder if this can be some supplicant / mac80211
>> stack issue...
>
> I just fired up my Thinkpad T510 with an Intel "Centrino Ultimate-N
> 6300" using iwlwifi, and it stays connected (does not appear to drop any
> packets).  This is also Fedora 18 x86_64 (slightly older kernel, but
> I've had the problem on the MacBook since I installed it).  There are
> other people in the office with the same MacBook hardware (but running
> OS X) that don't appear to be having any trouble either.
>
> The AP appears to be an Adtran (don't know the model).
>

Can you make a capture using a wireless sniffer (using your thinkpad maybe)?

Gr. AvS

