Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54906 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752387AbcIGKMj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 06:12:39 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mwifiex: handle edmac vendor command
Date: Wed, 7 Sep 2016 10:12:35 +0000
Message-ID: <f827ba80b79646fd8711e1a00c2b8394@SC-EXCH04.marvell.com> (sfid-20160907_121243_014228_55755044)
References: <1461945483-3239-1-git-send-email-akarwar@marvell.com>
        <cbd542a552db4d368a5b402307976494@SC-EXCH04.marvell.com>
        <87zirg8qxo.fsf@kamboji.qca.qualcomm.com>
        <e2b7d7d9aef1488a97eb7ec44b4c46af@SC-EXCH04.marvell.com>
        <87poon1xka.fsf@kamboji.qca.qualcomm.com>
        <0fa2b5d5e09f4396a9c273c3c8dfc3db@SC-EXCH04.marvell.com>
 <87d1km1hb6.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87d1km1hb6.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Friday, September 02, 2016 8:26 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH] mwifiex: handle edmac vendor command
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> >> Sorry for the delay. I have been thinking about vendor commands quite
> >> a lot and I don't think they belong to upstream drivers. For regular
> >> use cases (used by normal users) we have nl80211, for developer and
> >> testing purposes we have debugfs and for manufacturing type of tests
> >> we have
> >> nl80211 testmode interface. The focus of development should be adding
> >> new functionality to nl80211 (and other generic interfaces), not to
> >> driver specific vendor commands.
> >>
> >> I know brcm80211 and ti's wlcore have few vendor commands but I'm
> >> hoping to remove them sometime soon.
> >>
> >> Thoughts?
> >>
> >
> > Thanks for your reply.
> >
> > There is something called energy detect mode. Chip can detect non-WiFi
> > radio signal also and monitor it for specified time before
> > transmitting frames. As per ETSI specification, enabling this mode is
> > mandatory for some countries for certain frequencies.
> 
> To me this looks this is something which can be generic, not a driver
> specific interface. And why can't regulatory code enable this
> automatically, without any user involvement? It already knows what
> country we are in.
> 

Got it. I will check if we can make this as generic as you mentioned and explore the option.

Regards,
Amitkumar
