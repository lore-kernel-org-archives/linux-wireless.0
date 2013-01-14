Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:43976 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab3ANXuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 18:50:32 -0500
Received: by mail-lb0-f178.google.com with SMTP id l5so3384519lbo.9
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2013 15:50:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87hamjzxyf.fsf@purkki.adurom.net>
References: <CAMvjH0A69ZBCZc5qjm_cUYj3bDzSmneaz1u9CsPcJEm2T0Q1iw@mail.gmail.com>
 <87txqkz0yk.fsf@purkki.adurom.net> <CAMvjH0BkRS0HpjqHQyFOmnqmQs4AR9HGWh07FSz2yh3TiTBy6w@mail.gmail.com>
 <CAGRGNgXBNSRTK+zjaxg5eD-zDv6OE_S_iU7Gb3v5W=M_92qdrg@mail.gmail.com> <87hamjzxyf.fsf@purkki.adurom.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 15 Jan 2013 10:50:10 +1100
Message-ID: <CAGRGNgXmVOtKLvzinuS=EAwVJCxDvwWY2s-Jsiv8wstha+mxbA@mail.gmail.com> (sfid-20130115_005036_407171_147D7D89)
Subject: Re: Custom commands for cfg80211 based driver (like iwpriv)
To: Kalle Valo <kvalo@adurom.com>
Cc: Eugene <wifi.mailing.list@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Tue, Jan 15, 2013 at 12:38 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Julian Calaby <julian.calaby@gmail.com> writes:
>
>>> Why kernel do not support custom commands, like TESTMODE?
>>
>> The goal, as I understand it, is to work out a framework for how
>> TESTMODE could be implemented in a unified manner across all the
>> drivers for all hardware which supports it. I'm not sure that any real
>> progress has been made.
>
> I personally think that will never work out. With testmode we are
> talking about very low level features like RF registers, calibration, HW
> testing etc. Stuff which is only run in a factory or by an RF engineer.
> Finding a common interface for all HW designs is hard as they are so
> different.

You're a lot closer to actual hardware than I am so you've probably
got a better idea of what can and can't be done. I was just parroting
what I heard about it last time it was mentioned.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
