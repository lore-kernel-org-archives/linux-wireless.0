Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64619 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab0G0XdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 19:33:07 -0400
Received: by pwi5 with SMTP id 5so668865pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 16:33:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=rNVifMZ_8UzmWH=f26X0pT9UM5XT7U7wE2FWd@mail.gmail.com>
References: <AANLkTimo4RV6UMgti0ng1rQYE2eUVh2WLv_WHQZkz30j@mail.gmail.com>
	<AANLkTimr-tyyNfLz7c9hKVMwWm-5qQcsUniKmv8kvC8U@mail.gmail.com>
	<AANLkTi=rNVifMZ_8UzmWH=f26X0pT9UM5XT7U7wE2FWd@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 27 Jul 2010 16:26:41 -0700
Message-ID: <AANLkTimb0r0LJCpU76rrLibG=1o7j+UtcsFTmHeUHdXH@mail.gmail.com>
Subject: Re: iwlagn: two regressions 2.6.34->2.6.35-rc6
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 4:24 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Mon, Jul 26, 2010 at 3:48 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>> In the attached log, you'll see the one successful connection to
>>> 00:02:6f:6e:d7:6c as well as a failure.  The failure is just:
>>>
>>> [  668.569218] wlan0: authenticate with 00:02:6f:6e:d7:6c (try 1)
>>> [  668.769269] wlan0: authenticate with 00:02:6f:6e:d7:6c (try 2)
>>> [  668.969150] wlan0: authenticate with 00:02:6f:6e:d7:6c (try 3)
>>> [  669.169262] wlan0: authentication with 00:02:6f:6e:d7:6c timed out
>>
>> This time with actual attachment.
>
> Not sure if this is the same issue, but I've got another AP here
> (Ubiquiti RouterStation Pro + R52N ath9k minipci card running latest
> OpenWRT "backfire") that works quite nicely on 2.6.34 but requires me
> to reconnect every minute or so on 2.6.35-rc6+ to keep it working.

Define 2.6.35-rc6+

If you are using wireless-testing there was a regression there that I
just sent patches for.

Reporting issues is the way to go which BTW i have yet to get to your
other e-mail, sorry just got back from vacation and still catching up.
> I'm getting tempted to just revert the whole driver back to 2.6.34 and
> use the rest of 2.6.35 when it comes out.  I can also try to bisect,
> either the normal way or just the iwlwifi driver, but that'll have to
> wait until the Monday after next at least because I'm leaving town.
> If any of you have any ideas to test *today*, I can do it.
>
> This is a 5350, which I guess is somewhat rare given the general lack
> of WiMAX coverage.
>
> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



  Luis
