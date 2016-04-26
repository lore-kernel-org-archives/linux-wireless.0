Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:34593 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbcDZMNj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 08:13:39 -0400
Received: by mail-ig0-f193.google.com with SMTP id qu10so1936880igc.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 05:13:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461672224.16188.9.camel@sipsolutions.net>
References: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
	<CAAA5faGpa9ePaZagPpNaXdXz8FZrsDr=M4pMGEVO6F3xUc+aZA@mail.gmail.com>
	<1461664802.16188.8.camel@sipsolutions.net>
	<CAL3+40ExBLbSqJekDndBZkAsNf0pp5rTCga+SSujnsP9To4U=A@mail.gmail.com>
	<874maozlrs.fsf@kamboji.qca.qualcomm.com>
	<CABPxzYKFgOPMTs_i7OXCrA40FrNzrRvAVmLk63P-mPmrQiYRkQ@mail.gmail.com>
	<CAL3+40GYcS5Aou75mipFfikFYkUbsxmigpde7SdGPT=Mf1AjCA@mail.gmail.com>
	<87vb34y4we.fsf@kamboji.qca.qualcomm.com>
	<CAL3+40GiJPvMJMOq3aJnpExh0NncSu+9RTSbWtMoAUb=cnFbjg@mail.gmail.com>
	<1461672224.16188.9.camel@sipsolutions.net>
Date: Tue, 26 Apr 2016 13:13:38 +0100
Message-ID: <CAL3+40GE9bjoTmPVPtG72f-E8BwzProyg6QDuDPOOkkAh=cX7g@mail.gmail.com> (sfid-20160426_141342_589369_852550F0)
Subject: Re: Intel 7260 AC only using 802.11n not AC
From: Radu P <rrrpan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Reinoud Koornstra <reinoudkoornstra@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 26, 2016 at 1:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2016-04-26 at 12:54 +0100, Radu P wrote:
>> Is there a way running
>>
>> ./iw dev wlanX link
>>
>> but to get the output for the 5 Ghz frequency?
>> now I am getting only this:
>>
>> freq: 2432
>> tx bitrate: 130.0 MBit/s MCS 14 short GI
>
> Sure: connect to a 5 GHz AP first :)
>
> johannes

What a journey. The router has both frequencies. Changed the BSSID and
now I am in the AC world.
Thank you all for your help!
