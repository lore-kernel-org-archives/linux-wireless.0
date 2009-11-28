Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:56388 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbZK1UE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 15:04:27 -0500
Received: by ewy7 with SMTP id 7so2955403ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 12:04:33 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211 not using get_tx_stats driver op?
References: <87hbse8mx7.fsf@purkki.valot.fi>
	<1259438345.5428.30.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 28 Nov 2009 22:04:31 +0200
In-Reply-To: <1259438345.5428.30.camel@johannes.local> (Johannes Berg's message of "Sat\, 28 Nov 2009 20\:59\:05 +0100")
Message-ID: <87d4328lgw.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2009-11-28 at 21:33 +0200, Kalle Valo wrote:
>> Hello,
>> 
>> I noticed that mac80211 is not calling get_tx_stats op anywhere. Is
>> there a plan to use it somehow or can we just remove it?
>
> I thought there was a debugfs file for it?

If there is, I can't find it. I can see drivers implementing the op,
but I don't see mac80211 using it anywhere.

> I think I once wanted to remove it and then thought we'd keep the
> code ... there's probably little value in it unless somebody knows a
> use case?

If someone thinks of something, please tell me. Otherwise I will
submit a patch removing the code from both mac80211 and drivers. 

-- 
Kalle Valo
