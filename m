Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52220 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab1KYQS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 11:18:59 -0500
Received: by vcbfk14 with SMTP id fk14so2177392vcb.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 08:18:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87bos0hejm.fsf@purkki.adurom.net>
References: <CAJZjf_xDm_RaFqxF-r+MAPyh_HcCb+yV4dNrfhr+LH0-z2zk8g@mail.gmail.com>
 <CAJZjf_yEBb3BEf+-Fei78xBmJT1Y_Jr5fPUJNKwi6kvuVg24KA@mail.gmail.com> <87bos0hejm.fsf@purkki.adurom.net>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Fri, 25 Nov 2011 16:18:38 +0000
Message-ID: <CAJZjf_xpHgForL+2JjerEvx2McYMpT4xw08HMaz8dB33c3tQeA@mail.gmail.com> (sfid-20111125_171904_202601_AC99038C)
Subject: Re: iwl3945 firmware errors: tentative debugging
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trusting firmware logs, it uses both active and passive scans.

As to why, I don't know, though I suppose it'd make sense to let the
wireless card handle scanning unless some condition arised which led
NM to think it would have to roam soon.

On Fri, Nov 25, 2011 at 7:00 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Pedro Francisco <pedrogfrancisco@gmail.com> writes:
>
>>
>> I was able to trigger the firmware error by doing "iw dev wlan0 scan
>> passive". By comparison, "iw dev wlan0 scan" does NOT trigger the
>> firmware error.
>
> So NM uses passive scan? Now I'm curious, why is that?
>
