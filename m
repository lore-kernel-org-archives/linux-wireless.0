Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:34746 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab0G0Xqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 19:46:45 -0400
Received: by pxi14 with SMTP id 14so673730pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 16:46:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik2njXen5go8v2d8UPejC7THJiDJAvVunS7T5WU@mail.gmail.com>
References: <AANLkTimdDhHudW6_7Hwcf6UCumY_EgqGd7CLtmSgOzEz@mail.gmail.com>
	<AANLkTinfMiS=+dqi=azF2exJbkrSLYT9nN0aor7gff-Q@mail.gmail.com>
	<AANLkTi=Wy1r2C1xL289QQX10aVZaYfF7A1K8sd93ZXOd@mail.gmail.com>
	<AANLkTik2njXen5go8v2d8UPejC7THJiDJAvVunS7T5WU@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 27 Jul 2010 19:46:25 -0400
Message-ID: <AANLkTimZsj6+cp6YGoVFn06NEQR3ZBCAheaWHaKPZNK6@mail.gmail.com>
Subject: Re: regulatory hiccup
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 7:33 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>
>> AFAICT net/wireless/reg.c ignores the last bit, and the other APs that
>> work correctly here don't send country IEs.
>
> Can you provide the output of iw dev wlan0 scan from a fresh git
> version of iw? That will actually tell me more than your listing.

Unfortunately (or fortunately, I suppose) I can't, because a firmware
upgrade for the AP removed the country IE entirely.  But if we're
ignoring that data in 2.6.36 anyway, I'm not too worried.  If you
really want that data, I can downgrade the AP the week after next and
get it.

(FWIW, it looks like the Intel driver on Windows refused to work with
that AP but other people with macbooks could use it just fine.  I'd
guess that no one would complain if Linux ignored country IEs that
were transmitted outside their own "allowed" band, but this seems to
be moot anyway.)

--Andy

P.S.  My thread about the AP that works on 2.6.34 but can't associate
most of the time on 2.6.35-rc6 is the same AP but with the new
firmware.

>
>  Luis
>
