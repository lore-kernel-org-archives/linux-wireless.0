Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail01.spothost.nl ([77.74.49.150]:42728 "EHLO
	webmail01.spothost.nl" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751259Ab1HKOYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 10:24:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 11 Aug 2011 14:23:56 +0000
From: kc@cobradevil.org
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192cu sometimes it can authenticate to ap
In-Reply-To: <4E429C57.1040101@lwfinger.net>
References: <b3059ba2eac66b7ef0ec17c8fe81a1e6@cobradevil.org>
 <34676454425401d650be733a43191a53@cobradevil.org>
 <532595cb4d5ef910de54a4736ba76185@cobradevil.org>
 <4E41624E.3010904@lwfinger.net>
 <d3faeaf2e881a324b0ad3102c10e6131@cobradevil.org>
 <4E429C57.1040101@lwfinger.net>
Message-ID: <30cc9c22bb40fb1e2bd2b9ef4692d167@cobradevil.org> (sfid-20110811_162407_244434_52EEF038)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wed, 10 Aug 2011 09:57:27 -0500, Larry Finger wrote:
> On 08/10/2011 08:32 AM, kc@cobradevil.org wrote:
>> Hello Larry,
>>
>> did you receive my last email with the log files?
>> i'm not sure if that the right information so if you need more the 
>> please let me
>> know.
>
> Yes, I got them.
>
> So far, the only conclusion from them is that you should install the
> CRDA package. That is not the cause of your problem, but it needs to
> be done.
>
> I can duplicate the problem here and find that it occurs between 3.0
> and 3.1-rc1. I first tried to bisect testing only
> drivers/net/wireless/rtlwifi, net/mac80211 and net/wireless
> directories. That led to an impossible "bad" commit, thus I'm having
> to bisect the whole tree.

I have now tried several compat files til may 28 but none of them seems 
to work with maverick at all. Do i need some updated files on the client 
to be able to use the new compat tree?

I thought that the compat tree would work without changes on kernel 
from > 2.6.30 is that right?

>
> I'll let you know what I find.
>
> Larry

