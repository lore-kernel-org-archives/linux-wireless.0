Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65453 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758449AbZLIWyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 17:54:12 -0500
Received: by bwz27 with SMTP id 27so5713807bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 14:54:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87skbk35tx.fsf@purkki.valot.fi>
References: <c4d76b3b0912071955y25c31a11m104d9c4723ef578d@mail.gmail.com>
	 <87ws0x3ojk.fsf@purkki.valot.fi>
	 <c4d76b3b0912081947m2ffcdb65of44f4ce10dfa00d2@mail.gmail.com>
	 <87skbk35tx.fsf@purkki.valot.fi>
Date: Wed, 9 Dec 2009 17:54:18 -0500
Message-ID: <c4d76b3b0912091454o383ff350mce78d69565a1530c@mail.gmail.com>
Subject: Re: cfg80211 connect for at76c50x-usb
From: Jason Andryuk <jandryuk@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> However, there is still nothing seen on the monitor interface and it
>> is seeing plenty of other traffic. I am trying to filter with
>> wlan.addr == <Mac Address> in wireshark for what it's worth.
>>
>> Since I am not seeing anything with the CMD_JOIN being sent, I am
>> wondering if my device has failed.

A quick test under OpenBSD doesn't show any transmitted packets on the
monitor interface either and the device doesn't connect to the AP.
Makes me more suspicious of the device having failed.

Jason
