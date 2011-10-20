Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61913 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1JTLqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 07:46:53 -0400
Received: by wwe6 with SMTP id 6so4043830wwe.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 04:46:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+icZUXyYSVUA-PTCQB7z167iLAnh83DEJxOGoYB4qxaFkTZog@mail.gmail.com>
References: <1319109568.26974.YahooMailNeo@web161206.mail.bf1.yahoo.com>
	<CA+icZUXyYSVUA-PTCQB7z167iLAnh83DEJxOGoYB4qxaFkTZog@mail.gmail.com>
Date: Thu, 20 Oct 2011 17:16:51 +0530
Message-ID: <CAD2nsn3zkAgCf=_Y1CUt0X1qw7py4oEJ5sqaod_KYJxo68G1nQ@mail.gmail.com> (sfid-20111020_134655_301586_3AC520AF)
Subject: Re: ath5k: controlling powersave with iw or iwconfig fails
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: sedat.dilek@gmail.com
Cc: Joerg Pommnitz <pommnitz@yahoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-users@lists.ath5k.org" <ath5k-users@lists.ath5k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 20, 2011 at 5:03 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Which iw version?

looks like its ath5k does not supports station power save.
>
> - Sedat -
>
> On Thu, Oct 20, 2011 at 1:19 PM, Joerg Pommnitz <pommnitz@yahoo.com> wrote:
>> Hello all,
>> trying to disable PS on ath5k (Linux 3.0) gives:
>>
>> iw dev wlan0 set power_save off
>> command failed: Operation not supported (-95)
>>
>>
>> Is there any special magic required to disable power saving?
>> It seems to interfere with our amplifier...
>>
>>
>> --
>> Regards
>> Joerg
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
