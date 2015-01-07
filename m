Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55265 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbbAGQmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 11:42:52 -0500
Received: by mail-ie0-f177.google.com with SMTP id rd18so4586528iec.8
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 08:42:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420648358.3407.19.camel@sipsolutions.net>
References: <1420366399-31535-1-git-send-email-eliad@wizery.com>
	<1420542274.1966.21.camel@sipsolutions.net>
	<1420553111.1966.32.camel@sipsolutions.net>
	<1420553688.1966.33.camel@sipsolutions.net>
	<CAB3XZEctcBuPG6f4ZrZFV5O3Z7+hi+ShFdwvFXdJovG2KeAufQ@mail.gmail.com>
	<1420570976.1966.34.camel@sipsolutions.net>
	<CAB3XZEdWsDsnVr_bJ3ScSYy6MEQ7VXvWw4VC36zheYN-B=yLrA@mail.gmail.com>
	<CAB3XZEdJw=vaLVO+5YXkH1ZPerKYC4s-_+E0nzL+XUXMiZQLkw@mail.gmail.com>
	<1420648358.3407.19.camel@sipsolutions.net>
Date: Wed, 7 Jan 2015 18:42:51 +0200
Message-ID: <CAB3XZEeef1X6KcKByFQVknkjwjV8r3V5ya+xWw9SfGs6c6RWog@mail.gmail.com> (sfid-20150107_174306_417288_CB8D9A97)
Subject: Re: [PATCH 1/3] mac80211: consider only relevant vifs for
 radar_required calculation
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 7, 2015 at 6:32 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2015-01-07 at 17:58 +0200, Eliad Peller wrote:
>> ap_ht_40mhz_intolerant_ap still seems to fail here, but it fails even
>> when running only this test, without any of my patches applied.
>> now i get the same error with my patches applied ("Exception: AP did
>> not move to 40 MHz channel") instead of the EBUSY one.
>>
>> i'll try debugging this issue as well.
>
> Well, if you want to :)
> It's not related to your patches I think, and I saw it passing w/o your
> patches applied.
>
thanks.
looks like something bad in my setup.
i recompiled hostapd and it seems to pass now :)

Eliad.
