Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53674 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab0INWVg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 18:21:36 -0400
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
Subject: Re: [PATCH 08/10] mac80211: send last 3/5 probe requests as unicast
References: <1284474071-8404-1-git-send-email-lrodriguez@atheros.com>
	<87mxrk5610.fsf@purkki.adurom.net>
	<AANLkTikQx3RZcWPEjktBb0gkTLtMfCxXMma6h=9u+UBr@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 15 Sep 2010 01:21:35 +0300
In-Reply-To: <AANLkTikQx3RZcWPEjktBb0gkTLtMfCxXMma6h=9u+UBr@mail.gmail.com> (Luis R. Rodriguez's message of "Tue\, 14 Sep 2010 15\:15\:18 -0700")
Message-ID: <87iq2855lc.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@atheros.com> writes:

>> Beginning of this year I sent patches to use null funcs. Unfortunately
>> I had to drop them due to time constraints.
>>
>> Also a major power consumption imporovement from using null func
>> frames is that we don't have to trigger dynamic power save timer
>> during the poll. Just send the frame with PSM bit set, wait for ack
>> and go immeaditely back to sleep. So instead of having radios enabled
>> for example 100 ms per frame, we can do it in just 1 ms.
>
> Neat, do you have those patches dug up in a directory somewhere or
> should I dig the archives?

They are here:

http://marc.info/?l=linux-wireless&m=126644065026466&w=2

But I'm sure they don't apply anymore. You interested about patch 2:

http://marc.info/?l=linux-wireless&m=126644065926485&w=2

-- 
Kalle Valo
