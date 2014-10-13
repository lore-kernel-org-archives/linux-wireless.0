Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37077 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaJMJaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 05:30:24 -0400
Received: by mail-wg0-f46.google.com with SMTP id l18so8221332wgh.29
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2014 02:30:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <024a01cfe6c7$5e427dd0$1ac77970$@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A319018C2750@sbs2003.acksys.local>
	<CA+BoTQ=a8kY0CGGKHwRhk4cg=V0oimipuht6Pkc0K0x4WMMn-A@mail.gmail.com>
	<024a01cfe6c7$5e427dd0$1ac77970$@acksys.fr>
Date: Mon, 13 Oct 2014 11:30:22 +0200
Message-ID: <CA+BoTQkaKXNfprRwGrQq6rKOZWvANNRrcmgU-iVdw1bONTA--w@mail.gmail.com> (sfid-20141013_113028_045701_B75948B6)
Subject: Re: ath10k firmware crash
From: Michal Kazior <michal.kazior@tieto.com>
To: voncken <cedric.voncken@acksys.fr>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 October 2014 11:23, voncken <cedric.voncken@acksys.fr> wrote:
>
>
>>
>> Are you perhaps trying to run STA with 4addr bridging? If so then make sure
>> you use recent ath10k as this was known to be a problem.
>>
> We tested without the 4addr bridging, that works fine but we can't add the interface in bridge :-(
>
> Have you a benchmark reference with ATH10K ? at this time we can send around 700 Mbit/s, is it the maximum or we can expected better ?

If this is OTA then this is pretty good. If this is cabled RF w/
attentuator it should be possible to get ~900mbps of UDP traffic with
multiple streams on iperf. At least that's what I was getting on 10.1
firmware (on both AP and STA) last time I checked.

Getting more than 700mbps OTA requires AP and STA antenna alignment voodoo.


Michał
