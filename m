Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43865 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbaJTHWG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 03:22:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by gateway2.nyi.internal (Postfix) with ESMTP id C03AC20743
	for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 03:22:04 -0400 (EDT)
Message-Id: <1413789724.3063896.180943829.3F15F453@webmail.messagingengine.com> (sfid-20141020_092210_292349_FB9D59D3)
From: =?UTF-8?Q?Lauren=C8=9Biu=20Nicola?= <lnicola@dend.ro>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
In-Reply-To: <CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
 <1413510814.22769.6.camel@dcbw.local>
 <1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
 <CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>
 <1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com>
 <CANUX_P0Q7cNeBzQa=2WVZFJXPTLx8F6YQk9bGCf_3uYhc5RcGA@mail.gmail.com>
 <CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com>
Subject: Re: iwlwifi: Reason 7 periodic disconnect
Date: Mon, 20 Oct 2014 10:22:04 +0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One thing that might be relevant is that, although there is a static
DHCP lease configured (which works on Windows), the router/AP is giving
the laptop a different IP address. The reported MACs are the same, of
course. I don't know whether wpa_supplicant remembers and requests the
last IP it had, but the lease was already present when I configured it.

The router runs DD-WRT and I don't have problems on Windows or Android.

Laurentiu

On Mon, Oct 20, 2014, at 10:12, Emmanuel Grumbach wrote:
> On Mon, Oct 20, 2014 at 10:06 AM, Emmanuel Grumbach <egrumbach@gmail.com>
> wrote:
> > On Mon, Oct 20, 2014 at 8:30 AM, Laurențiu Nicola <lnicola@dend.ro> wrote:
> >> Here: https://bpaste.net/show/bf6dc1847ce3
> >>
> >
> > Are you sure you had MAC80211_MLME_DEBUG?
> >
> >>
> Ok - You probably had it - sorry. But apparently the AP is really kicking
> us...
> What AP do you have?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
