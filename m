Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34036 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2H3BgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 21:36:01 -0400
Received: by vbbff1 with SMTP id ff1so1338878vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2012 18:36:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503E8B03.4070905@lwfinger.net>
References: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com>
	<50365AC8.7030503@lwfinger.net>
	<CAE3CJbm5a0hZ8uWT8yU5Z8vbKX2HNwZ2uPUFULGA-3no1XFc_Q@mail.gmail.com>
	<5036660B.9020208@lwfinger.net>
	<CAE3CJbkodiw7kZ9F1PQrzZA2hSCF2PAwPAw-UHMwKhC2-6Ky2g@mail.gmail.com>
	<50381437.7040903@lwfinger.net>
	<CAE3CJb=Zi12MVpBNGE3kOu00x3b1sZ7S67TCyBty3GkPbtoJXA@mail.gmail.com>
	<CAE3CJbmK4nF2gR56Rkrrd8qWoCuLot=XD-a9koWxCzcDeOrg8A@mail.gmail.com>
	<CAE3CJbmJ8JZzBKKJwYAL_6K_ossMK0HDCEkNLNfG-A4HzZSfzg@mail.gmail.com>
	<CAE3CJbm++cjK0Mf8JOsRk8vCkvKF97iw1SnJdySjc7vXUz1Qgg@mail.gmail.com>
	<503E8B03.4070905@lwfinger.net>
Date: Wed, 29 Aug 2012 18:36:00 -0700
Message-ID: <CAE3CJbkXy_amHwvjMSYc=UaeYzU7zFs0cGJ__hjZeSGKvv=jjg@mail.gmail.com> (sfid-20120830_033611_783363_434EEC98)
Subject: Re: Question about ath9k/mac80211 Driver
From: Patrick Connolly <pjc999@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,
     Thanks for responding...
      I tried both the compat-wireless-3.5.1-1-snpc you recommended
and even  compat-wireless-3.5.1-1-sn but the "iw set bitrates" command
still doesn't change the advertised bit rates on the beacons.

      What do we make of this?  Do you (or anyone) have any idea
what's going on?  Are we sure that this driver really works with the
AR9285 chip ...ie has at least one person verified it to be working
and/or is it working in at least one product?    Is there a
recommended way to debug or trace this such as with printk's in the
beacon.c file (or similar) or higher up?

-Patrick


On Wed, Aug 29, 2012 at 2:34 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> On 08/29/2012 04:09 PM, Patrick Connolly wrote:
>>
>> Can anyone comment on whether "iw set bitrates" should be fully
>> functional using compat-wireless version 3.2.5-1 ?
>>     ( if not, what do I have to do to get this to work? )
>
>
> The version of compat-wireless (3.2.5) is the version of the kernel that is backported, and I don't think that is new enough.
>
> If you use the version at
> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5.1-1-snpc.tar.bz2, you should be OK.
>
> Larry
>
>
