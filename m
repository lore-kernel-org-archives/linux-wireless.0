Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53768 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZLDPY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 10:24:28 -0500
Received: by bwz27 with SMTP id 27so2029364bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2009 07:24:33 -0800 (PST)
To: David Acker <dacker@roinet.com>
Cc: linux-wireless@vger.kernel.org, patrik.flykt@nokia.com
Subject: Re: WMM classification guideline for applications?
References: <87d42u6dnd.fsf@purkki.valot.fi> <4B19276F.5080604@roinet.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 04 Dec 2009 17:24:30 +0200
In-Reply-To: <4B19276F.5080604@roinet.com> (David Acker's message of "Fri\, 04 Dec 2009 10\:14\:55 -0500")
Message-ID: <878wdi69u9.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Acker <dacker@roinet.com> writes:

> Kalle Valo wrote:
>> Hello,
>>
>> me and Patrik have been pondering what's the proper way for user space
>> applications to do packet classification to get the benefits from WMM.
>> VoIP application is a good example here.
>>
>> For the time being we have identified three different methods:
>>
>> 1. SO_PRIORITY with values 0-7 (we used this in nokia n810)
>> 2. SO_PRIORITY with values 256-263 (used by mac80211)
>> 3. IPv4 DSCP field with values 0-7 (used by mac80211)

[...]

> What do think of also supporting a method 4, VLAN priority field (0-7)?

Sorry, I haven't heard about this. I don't even know how applications
should set this. Can you show an example, please?

-- 
Kalle Valo
