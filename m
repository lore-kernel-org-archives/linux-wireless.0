Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53520 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaJOMNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2014 08:13:52 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so1185398wgg.25
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2014 05:13:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <025801cfe6de$2d4c7f70$87e57e50$@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A319018C2750@sbs2003.acksys.local>
	<CA+BoTQ=a8kY0CGGKHwRhk4cg=V0oimipuht6Pkc0K0x4WMMn-A@mail.gmail.com>
	<024a01cfe6c7$5e427dd0$1ac77970$@acksys.fr>
	<CA+BoTQkaKXNfprRwGrQq6rKOZWvANNRrcmgU-iVdw1bONTA--w@mail.gmail.com>
	<025801cfe6de$2d4c7f70$87e57e50$@acksys.fr>
Date: Wed, 15 Oct 2014 14:13:50 +0200
Message-ID: <CACKGw+H1QSvAL0Ri3HT6E_rhw=DhzDwj1XEeqwjwFkzJVQpz9Q@mail.gmail.com> (sfid-20141015_141356_014478_BF60801D)
Subject: Re: ath10k firmware crash
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: voncken <cedric.voncken@acksys.fr>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	ath10k <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 October 2014 14:06, voncken <cedric.voncken@acksys.fr> wrote:
>> >
>> > Have you a benchmark reference with ATH10K ? at this time we can send
>> around 700 Mbit/s, is it the maximum or we can expected better ?
>>
>> If this is OTA then this is pretty good. If this is cabled RF w/ attentuator
>> it should be possible to get ~900mbps of UDP traffic with multiple streams on
>> iperf. At least that's what I was getting on 10.1 firmware (on both AP and
>> STA) last time I checked.
>>
>> Getting more than 700mbps OTA requires AP and STA antenna alignment voodoo.
>>
> I did some tests with a linksys WRT1900AC and I have ~950 mbps OTA easily.

You mean ath10k (STA) VS WRT1900AC get up ~950mbps?
If so, could you say what's the HW, FW version you use?

-- 
Bartosz
