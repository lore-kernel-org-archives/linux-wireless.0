Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51079 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab3EONTd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 09:19:33 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Dan Williams <dcbw@redhat.com>
Cc: nick@nhthomas.freeserve.co.uk, linux-wireless@vger.kernel.org
Subject: Re: Wifi signal level differences
References: <7566504.38231368021104217.JavaMail.www@wwinf3714>
	<1368023384.1664.10.camel@dcbw.foobar.com>
Date: Wed, 15 May 2013 16:19:31 +0300
In-Reply-To: <1368023384.1664.10.camel@dcbw.foobar.com> (Dan Williams's
	message of "Wed, 08 May 2013 09:29:44 -0500")
Message-ID: <871u985qjg.fsf@purkki.adurom.net> (sfid-20130515_151937_355428_532FE3E5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> On Wed, 2013-05-08 at 15:51 +0200, nick@nhthomas.freeserve.co.uk wrote:
>> Hi,
>> 
>> I have an Atheros ath6kl_usb based wifi dongle.
>> I am using it with an embedded project.

[...]

> What kernel versions is each system running?  The kernel's mac80211
> stack is what calculates the actual dBm/RSSI value based on information
> given from the dongle firmware.  And the calculations may change in
> different kernel versions.

ath6kl is a fullmac device and doesn't use mac80211.

-- 
Kalle Valo
