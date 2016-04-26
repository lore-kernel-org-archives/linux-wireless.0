Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33544 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbcDZLyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 07:54:19 -0400
Received: by mail-io0-f196.google.com with SMTP id x35so1761094ioi.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 04:54:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87vb34y4we.fsf@kamboji.qca.qualcomm.com>
References: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
	<CAAA5faGpa9ePaZagPpNaXdXz8FZrsDr=M4pMGEVO6F3xUc+aZA@mail.gmail.com>
	<1461664802.16188.8.camel@sipsolutions.net>
	<CAL3+40ExBLbSqJekDndBZkAsNf0pp5rTCga+SSujnsP9To4U=A@mail.gmail.com>
	<874maozlrs.fsf@kamboji.qca.qualcomm.com>
	<CABPxzYKFgOPMTs_i7OXCrA40FrNzrRvAVmLk63P-mPmrQiYRkQ@mail.gmail.com>
	<CAL3+40GYcS5Aou75mipFfikFYkUbsxmigpde7SdGPT=Mf1AjCA@mail.gmail.com>
	<87vb34y4we.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 26 Apr 2016 12:54:18 +0100
Message-ID: <CAL3+40GiJPvMJMOq3aJnpExh0NncSu+9RTSbWtMoAUb=cnFbjg@mail.gmail.com> (sfid-20160426_135423_212321_EA377BEE)
Subject: Re: Intel 7260 AC only using 802.11n not AC
From: Radu P <rrrpan@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinoud Koornstra <reinoudkoornstra@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 26, 2016 at 12:40 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Radu P <rrrpan@gmail.com> writes:
>
>> With the latest iw from the git repo I get:
>>
>>                 VHT Capabilities (0x038071a0):
>>                         Max MPDU length: 3895
>>                         Supported Channel Width: neither 160 nor 80+80
>>                         short GI (80 MHz)
>>                         TX STBC
>>                         SU Beamformee
>>                 VHT RX MCS set:
>>                         1 streams: MCS 0-9
>>                         2 streams: MCS 0-9
>>                         3 streams: not supported
>>                         4 streams: not supported
>>                         5 streams: not supported
>>                         6 streams: not supported
>>                         7 streams: not supported
>>                         8 streams: not supported
>>                 VHT RX highest supported: 0 Mbps
>>                 VHT TX MCS set:
>>                         1 streams: MCS 0-9
>>                         2 streams: MCS 0-9
>>                         3 streams: not supported
>>                         4 streams: not supported
>>                         5 streams: not supported
>>                         6 streams: not supported
>>                         7 streams: not supported
>>                         8 streams: not supported
>>                 VHT TX highest supported: 0 Mbps
>>
>> Is it OK that it is reporting  "VHT TX highest supported: 0 Mbps" ?
>
> Yeah, zero just means that the highest support rate is not defined. I
> guess it's nicer if iw would print "Not defined" instead of "0 Mbps" but
> nobody hasn't implemented that yet.
>
> --
> Kalle Valo


Is there a way running

./iw dev wlanX link

but to get the output for the 5 Ghz frequency?
now I am getting only this:

freq: 2432
tx bitrate: 130.0 MBit/s MCS 14 short GI
