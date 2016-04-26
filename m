Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:36467 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbcDZLR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 07:17:59 -0400
Received: by mail-ig0-f193.google.com with SMTP id c3so1566926igl.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 04:17:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYKFgOPMTs_i7OXCrA40FrNzrRvAVmLk63P-mPmrQiYRkQ@mail.gmail.com>
References: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
	<CAAA5faGpa9ePaZagPpNaXdXz8FZrsDr=M4pMGEVO6F3xUc+aZA@mail.gmail.com>
	<1461664802.16188.8.camel@sipsolutions.net>
	<CAL3+40ExBLbSqJekDndBZkAsNf0pp5rTCga+SSujnsP9To4U=A@mail.gmail.com>
	<874maozlrs.fsf@kamboji.qca.qualcomm.com>
	<CABPxzYKFgOPMTs_i7OXCrA40FrNzrRvAVmLk63P-mPmrQiYRkQ@mail.gmail.com>
Date: Tue, 26 Apr 2016 12:17:58 +0100
Message-ID: <CAL3+40GYcS5Aou75mipFfikFYkUbsxmigpde7SdGPT=Mf1AjCA@mail.gmail.com> (sfid-20160426_131804_243499_9CA40A12)
Subject: Re: Intel 7260 AC only using 802.11n not AC
From: Radu P <rrrpan@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinoud Koornstra <reinoudkoornstra@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 26, 2016 at 12:04 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Tue, Apr 26, 2016 at 4:20 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Radu P <rrrpan@gmail.com> writes:
>>
>> > iw list|grep -i VHT  <- still nothing
>>
>> Maybe your iw is too old? I didn't see anything either (using stock iw
>> from Ubuntu 14.04) but then I upgraded to the latest one from git and
>> now I see:
>>
>>                VHT Capabilities (0x338001b2):
>>                         Max MPDU length: 11454
>>                         Supported Channel Width: neither 160 nor 80+80
>>                         RX LDPC
>>                         short GI (80 MHz)
>>                         TX STBC
>>                         RX antenna pattern consistency
>>                         TX antenna pattern consistency
>>                 VHT RX MCS set:
>>                         1 streams: MCS 0-9
>>                         2 streams: MCS 0-9
>>                         3 streams: MCS 0-9
>>                         4 streams: not supported
>>                         5 streams: not supported
>>                         6 streams: not supported
>>                         7 streams: not supported
>>                         8 streams: not supported
>>                 VHT RX highest supported: 0 Mbps
>>                 VHT TX MCS set:
>>                         1 streams: MCS 0-9
>>                         2 streams: MCS 0-9
>>                         3 streams: MCS 0-9
>>                         4 streams: not supported
>>                         5 streams: not supported
>>                         6 streams: not supported
>>                         7 streams: not supported
>>                         8 streams: not supported
>>                 VHT TX highest supported: 0 Mbps
>>
>> And please don't top post.
>>
>> --
> "iw phy " should give necessary info.



With the latest iw from the git repo I get:

                VHT Capabilities (0x038071a0):
                        Max MPDU length: 3895
                        Supported Channel Width: neither 160 nor 80+80
                        short GI (80 MHz)
                        TX STBC
                        SU Beamformee
                VHT RX MCS set:
                        1 streams: MCS 0-9
                        2 streams: MCS 0-9
                        3 streams: not supported
                        4 streams: not supported
                        5 streams: not supported
                        6 streams: not supported
                        7 streams: not supported
                        8 streams: not supported
                VHT RX highest supported: 0 Mbps
                VHT TX MCS set:
                        1 streams: MCS 0-9
                        2 streams: MCS 0-9
                        3 streams: not supported
                        4 streams: not supported
                        5 streams: not supported
                        6 streams: not supported
                        7 streams: not supported
                        8 streams: not supported
                VHT TX highest supported: 0 Mbps

Is it OK that it is reporting  "VHT TX highest supported: 0 Mbps" ?
