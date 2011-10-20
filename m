Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm24-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.161]:24370 "HELO
	nm24-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751470Ab1JTLqd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 07:46:33 -0400
References: <1319109568.26974.YahooMailNeo@web161206.mail.bf1.yahoo.com> <CA+icZUXyYSVUA-PTCQB7z167iLAnh83DEJxOGoYB4qxaFkTZog@mail.gmail.com>
Message-ID: <1319111192.54460.YahooMailNeo@web161206.mail.bf1.yahoo.com> (sfid-20111020_134637_008105_F64E7B10)
Date: Thu, 20 Oct 2011 04:46:32 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Reply-To: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: ath5k: controlling powersave with iw or iwconfig fails
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-users@lists.ath5k.org" <ath5k-users@lists.ath5k.org>
In-Reply-To: <CA+icZUXyYSVUA-PTCQB7z167iLAnh83DEJxOGoYB4qxaFkTZog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iw is 0.9.22, but I just found part of the answer myself. Controlling PS in 

IBSS mode is not supported (I failed to mention the IBSS part in my previous 

mail).

Question: Is any power saving going on in IBSS mode at all? I'm seeing lots 

of Probe-Requests that I thought were related to PS.

 
-- 
Regards 
Joerg 



----- Ursprüngliche Message -----
> Von: Sedat Dilek <sedat.dilek@googlemail.com>
> An: Joerg Pommnitz <pommnitz@yahoo.com>
> Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>; "ath5k-users@lists.ath5k.org" <ath5k-users@lists.ath5k.org>
> Gesendet: 13:33 Donnerstag, 20.Oktober 2011 
> Betreff: Re: ath5k: controlling powersave with iw or iwconfig fails
> 
> Which iw version?
> 
> - Sedat -
> 
> On Thu, Oct 20, 2011 at 1:19 PM, Joerg Pommnitz <pommnitz@yahoo.com> 
> wrote:
>>  Hello all,
>>  trying to disable PS on ath5k (Linux 3.0) gives:
>> 
>>  iw dev wlan0 set power_save off
>>  command failed: Operation not supported (-95)
>> 
>> 
>>  Is there any special magic required to disable power saving?
>>  It seems to interfere with our amplifier...
>> 
>> 
>>  --
>>  Regards
>>  Joerg
>> 
>>  --
>>  To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
>>  the body of a message to majordomo@vger.kernel.org
>>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>
