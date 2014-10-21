Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45411 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906AbaJUIXN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 04:23:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by gateway2.nyi.internal (Postfix) with ESMTP id 26B2D209B2
	for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 04:23:12 -0400 (EDT)
Message-Id: <1413879792.3500640.181427549.198E9452@webmail.messagingengine.com> (sfid-20141021_102319_350788_B8637EDF)
From: =?UTF-8?Q?Lauren=C8=9Biu=20Nicola?= <lnicola@dend.ro>
To: Felix Fietkau <nbd@openwrt.org>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
In-Reply-To: <54461740.5000903@openwrt.org>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
 <1413510814.22769.6.camel@dcbw.local>
 <1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
 <CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>
 <1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com>
 <CANUX_P0Q7cNeBzQa=2WVZFJXPTLx8F6YQk9bGCf_3uYhc5RcGA@mail.gmail.com>
 <CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com>
 <1413789724.3063896.180943829.3F15F453@webmail.messagingengine.com>
 <CANUX_P1REqkSqN0dtak34OQ_pSGMtPvV3Vj61tW5wb1+n2A7mg@mail.gmail.com>
 <1413833365.2949853.181221645.22D54845@webmail.messagingengine.com>
 <CANUX_P3XzYBp7E=hScmc837TpuCr9VrxEYauG=sGMKfOCpX=qA@mail.gmail.com>
 <54461740.5000903@openwrt.org>
Subject: Re: iwlwifi: Reason 7 periodic disconnect
Date: Tue, 21 Oct 2014 11:23:12 +0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's an ASUS RT-N66U running NEWD-2/K3X from r24160.

Laurentiu

On Tue, Oct 21, 2014, at 11:20, Felix Fietkau wrote:
> On 2014-10-21 07:02, Emmanuel Grumbach wrote:
> > On Mon, Oct 20, 2014 at 10:29 PM, Laurențiu Nicola <lnicola@dend.ro> wrote:
> >> No, nothing in the DD-WRT syslog. The IP seems to be the one cached by
> >> my DHCP client. I also tried various suggestions found on the internet,
> >> but nothing helped.
> >>
> > 
> > Can you please try to have another device in monitor mode to sniff the
> > traffic going on?
> > Felix, can you please tell me when DD-WRT can send a deauth with reason code 7?
> What kind of device is it, and what software version?
> 
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
