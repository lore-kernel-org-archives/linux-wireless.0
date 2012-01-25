Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62482 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2AYHxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 02:53:44 -0500
Received: by pbaa10 with SMTP id a10so2826107pba.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 23:53:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F1F2837.5090307@maya.org>
References: <4F1EF618.6080108@01019freenet.de>
	<13411135.eH6opTgxBo@helmutmobil.site>
	<4F1F2837.5090307@maya.org>
Date: Wed, 25 Jan 2012 08:53:43 +0100
Message-ID: <CAGXE3d_a9qOtyj8RFYgOjebmB=MProO8V7FsoF=NMJ41q2xyGA@mail.gmail.com> (sfid-20120125_085436_074660_46F9237D)
Subject: Re: ath9k get's completely knocked out by rt3572 device
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 24, 2012 at 10:52 PM, Andreas Hartmann
<andihartmann@freenet.de> wrote:
> Helmut Schaa schrieb:
>> Am Dienstag, 24. Januar 2012, 19:19:04 schrieb Andreas Hartmann:
>>> - At the moment of stopping netperf on rt3572, the ath9k device
>>> instantly started sending / receiving data again as expected.
>> [...]
>>> Does anybody has an idea what could cause this situation? Or is this normal?
>>
>> Your netperf traffic is in the direction STA -> AP or also in the other
>> direction?
>
> In both directions (serially). It's a script, which does the following:
>
> while true
> do
>        netperf -H host -t TCP_STREAM    # (STA -> AP)
>        netperf -H host -t TCP_MAERTS    # (AP -> STA)
>        netperf -H host -t TCP_SENDFILE  # (STA -> AP)
> done

Can you reproduce the ath9k tx starving issue with just STA->AP traffic too?
And what about pure AP->STA traffic?

Helmut
