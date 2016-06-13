Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38724 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbcFMTZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 15:25:18 -0400
Received: by mail-wm0-f48.google.com with SMTP id m124so93215207wme.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2016 12:25:18 -0700 (PDT)
Subject: Re: NL80211_ATTR_PAD question
To: Johannes Berg <johannes@sipsolutions.net>,
	Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <575B1964.2030806@candelatech.com>
 <1465592932.2308.6.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <575F089C.3020201@broadcom.com> (sfid-20160613_212524_217769_6D0403DD)
Date: Mon, 13 Jun 2016 21:25:16 +0200
MIME-Version: 1.0
In-Reply-To: <1465592932.2308.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10-06-16 23:08, Johannes Berg wrote:
> On Fri, 2016-06-10 at 12:47 -0700, Ben Greear wrote:
>> I see this was added sometime recently:  NL80211_ATTR_PAD
>>
>> If another enum member is added, should it replace the PAD enum?
> 
> No.
> 
>> At the least, I think we need some comments about how this is to be
>> dealt with.
>>
> 
> You simply ignore it :)

So do you know why the caller of nla_put_u64_64bit() would need to
specify the padattr. I mean, why is this not an generic attribute that
netlink deals with internally. It has probably been discussed on the
netdev list but I could not find the right thread.

Regards,
Arend
