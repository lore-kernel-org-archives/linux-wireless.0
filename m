Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:44977 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbaJUIUT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 04:20:19 -0400
Message-ID: <54461740.5000903@openwrt.org> (sfid-20141021_102029_197338_E6B23E1A)
Date: Tue, 21 Oct 2014 10:20:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	=?UTF-8?B?TGF1cmVuyJtpdSBOaWM=?= =?UTF-8?B?b2xh?=
	<lnicola@dend.ro>
CC: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi: Reason 7 periodic disconnect
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>	<1413510814.22769.6.camel@dcbw.local>	<1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>	<CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>	<1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com>	<CANUX_P0Q7cNeBzQa=2WVZFJXPTLx8F6YQk9bGCf_3uYhc5RcGA@mail.gmail.com>	<CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com>	<1413789724.3063896.180943829.3F15F453@webmail.messagingengine.com>	<CANUX_P1REqkSqN0dtak34OQ_pSGMtPvV3Vj61tW5wb1+n2A7mg@mail.gmail.com>	<1413833365.2949853.181221645.22D54845@webmail.messagingengine.com> <CANUX_P3XzYBp7E=hScmc837TpuCr9VrxEYauG=sGMKfOCpX=qA@mail.gmail.com>
In-Reply-To: <CANUX_P3XzYBp7E=hScmc837TpuCr9VrxEYauG=sGMKfOCpX=qA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-10-21 07:02, Emmanuel Grumbach wrote:
> On Mon, Oct 20, 2014 at 10:29 PM, Laurențiu Nicola <lnicola@dend.ro> wrote:
>> No, nothing in the DD-WRT syslog. The IP seems to be the one cached by
>> my DHCP client. I also tried various suggestions found on the internet,
>> but nothing helped.
>>
> 
> Can you please try to have another device in monitor mode to sniff the
> traffic going on?
> Felix, can you please tell me when DD-WRT can send a deauth with reason code 7?
What kind of device is it, and what software version?

- Felix
