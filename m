Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:65020 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbbAMCzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 21:55:35 -0500
Received: by mail-wi0-f173.google.com with SMTP id em10so2597583wid.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 18:55:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87a91oeaq7.fsf@home.hong.me>
References: <1420968029-1222-1-git-send-email-hong@topbug.net>
 <20150112065445.GB29484@localhost> <87a91oeaq7.fsf@home.hong.me>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 13 Jan 2015 13:55:13 +1100
Message-ID: <CAGRGNgUdEemrqnrYnJzTQEuce4yjQUjOW3B_eWSHkENkPwO9UQ@mail.gmail.com> (sfid-20150113_035539_200096_10CCFAF2)
Subject: Re: [PATCH] ath9k_htc: Add a module parameter to disable blink
To: Hong Xu <hong@topbug.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hong,

On Mon, Jan 12, 2015 at 6:09 PM, Hong Xu <hong@topbug.net> wrote:
>
> Bob Copeland <me@bobcopeland.com> writes:
>
>> On Sun, Jan 11, 2015 at 01:20:29AM -0800, Hong Xu wrote:
>>> Add an option "blink" to enable or disable the LED blink. The default
>>> value is set to 1 so that existing users would not experience any
>>> unexpected changes.
>>
>> Been a while since I looked, but isn't there a way to achieve same
>> result by just echoing 'none' into the relevant LED's sysfs file
>> (something like /sys/class/leds/phy0-led/trigger)?
>
> It's a bit different. echo 'none' to the trigger would cause the LED
> light to be dark, but if turn off the blink option here, the LED is
> bright but without blinking.
>
> Hong

I.e. it doesn't blink, it's just on when linked (isn't there a trigger
for that?) or is on solid? (echo 255 >
/sys/class/leds/phy0-led/brightness)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
