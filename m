Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:40921 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbZEaO4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 10:56:48 -0400
Received: by bwz22 with SMTP id 22so7012737bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 07:56:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4dd58f490905310754g2f01b083sd35831747ff93d4f@mail.gmail.com>
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>
	 <4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
	 <20090304232527.058017da.cjsthompson@gmail.com>
	 <4dd58f490903051449h3b2eb96ay5d83d7ea8129370f@mail.gmail.com>
	 <20090306084527.5a3b6300.cjsthompson@gmail.com>
	 <4dd58f490903101404m3678728ag13735851e232a8f4@mail.gmail.com>
	 <20090310223757.a8618b61.cjsthompson@gmail.com>
	 <b6c5339f0903101458k1aaf9455x80a0288daf46a4e3@mail.gmail.com>
	 <4dd58f490903111451u4107936du6466d134f0c119d3@mail.gmail.com>
	 <4dd58f490905310754g2f01b083sd35831747ff93d4f@mail.gmail.com>
Date: Sun, 31 May 2009 15:56:47 +0100
Message-ID: <4dd58f490905310756y2545b0e5lf291f396151aed5@mail.gmail.com>
Subject: Re: ath5k master (AP) mode
From: Alexey Yudichev <ayudichev@yahoo.co.uk>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to finish the thread. After all the issues I had I decided to
wait until all patches make it into the official tree. Yesterday I've
downloaded the latest compat-wireless, hostapd 0.6.9, installed it and
everything worked out of the box, including open mode and WPA and on
both WM6 smartphone and WM5 pocket pc. And that's on 2.6.27-14 kernel
(currently latest ubuntu kernel). Thanks everybody for the great work!

>
> On Wed, Mar 11, 2009 at 10:51 PM, Alexey Yudichev <ayudichev@yahoo.co.uk> wrote:
>>
>> > On Tue, Mar 10, 2009 at 5:37 PM, Christoph .J Thompson
>> > <cjsthompson@gmail.com> wrote:
>> >> On Tue, 10 Mar 2009 21:04:17 +0000
>> >> Alexey Yudichev <ayudichev@yahoo.co.uk> wrote:
>> >>> Do you know, if I got this far, can unstable connection and not
>> >>> working WPA be related to older kernel?
>> >>
>> >> I can't be sure. I don't have the unstable connection problem but I didn't
>> >> use WPA yet. So maybe the unstable connection problem only happens with WPA.
>> >
>> > It's possible ath5k has bugs in the crypto for AP mode like the ones fixed
>> > in ath9k recently - you can always try the nohwcrypt=1 modparam.
>> >
>> > --
>> > Bob Copeland %% www.bobcopeland.com
>> >
>> nohwcrypt=1 did not help (was I correct to put it as "options ath5k
>> nohwcrypt=1" into /etc/modprobe.d/options in my ubuntu?).
>>
>> The problem is not that WPA does not work. It works for my WM6 client
>> (who connects with or without WPA from some 2nd or 3rd attempt but
>> cannot browse anything anyway even without encryption) but does not
>> work for WM5 client (who can browse but only when it connects and it
>> only connects with WPA disabled). Not sure which component to blame
>> here. Both devices work so nicely with WPA with hardware wireless
>> router :)
>>
>> I guess I'll just wait for future versions of driver and kernel and
>> keep upgrading hoping that it'll start working.
>
