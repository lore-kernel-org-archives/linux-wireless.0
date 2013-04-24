Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:34245 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab3DXO3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 10:29:30 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC] cfg80211: Android P2P-Device workaround
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <51779434.4010709@broadcom.com>
Date: Wed, 24 Apr 2013 07:29:28 -0700
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Message-Id: <F323F29D-5EF8-4D01-A4B3-F9AF12326012@holtmann.org> (sfid-20130424_162933_221569_793DB5BC)
References: <1366721149-5440-1-git-send-email-johannes@sipsolutions.net> <EC4E16A7-2F9E-4E59-A561-88C85A459BCA@holtmann.org> <1366735340.8385.20.camel@jlt4.sipsolutions.net> <51779434.4010709@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

>>>> +config CFG80211_ANDROID_P2P_HACK
>>>> +	bool "Android P2P netdevice hack"
>>>> +	depends on CFG80211
>>>> +	depends on !CFG80211_WEXT
>>>> +	help
>>>> +	  Enable this option for Android P2P w/ P2P Device.
>>>> +
>>> 
>>> do you really think this is a good idea? Wouldn't it be better if
>>> Android just gets its userspace fixed. This way, they never will and
>>> you carry this workaround forever.
>> 
>> Well, I'm about 50/50 on whether to merge this. On the one hand, it's a
>> very simple patch to carry out of tree, on the other hand more than one
>> person will need it.
>> 
> 
> Here is one who needs it. I consider this patch as a temporary solution, but it would be good to have it upstream. We would be using compat-drivers to backport the upstream brcmfmac to the android kernel, which also takes care of cfg80211.

why do I get the feeling that the root-cause for this stupid p2p0 device is the Broadcom binary only driver  ;)

I feel like being back in the world of Wireless Extensions ;)

Regards

Marcel

