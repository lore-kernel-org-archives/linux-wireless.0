Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:43540 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbbAFSBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 13:01:42 -0500
Received: by mail-ie0-f178.google.com with SMTP id vy18so4066566iec.9
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 10:01:41 -0800 (PST)
Received: from mail-ig0-f180.google.com (mail-ig0-f180.google.com. [209.85.213.180])
        by mx.google.com with ESMTPSA id s10sm5291468igr.2.2015.01.06.10.01.39
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 06 Jan 2015 10:01:39 -0800 (PST)
Received: by mail-ig0-f180.google.com with SMTP id h15so8468igd.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 10:01:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rxF1OKRZSpaL=+XzSV2kCpMH5LuB-B+eWV7zF8MJ-9tog@mail.gmail.com>
References: <1420127170-28421-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CACna6rznUcqGTK0t1k=kjn0NVLycq865780ozyB+VYu78d_BSg@mail.gmail.com>
	<CACna6rxbGRdw7XSYvHAJGxJvMVwjVbAL4ynBM3m9rNggh7gCVQ@mail.gmail.com>
	<CA+icZUWOXMEyobZkudW9BEfkaWFTXQL9XF26g7oJMCzt=4==6g@mail.gmail.com>
	<CAKXHbyO70WdWekSYCY9spMbX2+_kdKTp3JoreDKpCdUBzFwYqw@mail.gmail.com>
	<CACna6rxTYUWvxvu0rFydWxkjbYdHfhV=o+9A+ViCpbV-LFx7fw@mail.gmail.com>
	<CAKXHbyMqTk=k7eieBNtAD+n6+4w3weL82twHBo-o8ebm_3+wvg@mail.gmail.com>
	<CACna6rxF1OKRZSpaL=+XzSV2kCpMH5LuB-B+eWV7zF8MJ-9tog@mail.gmail.com>
Date: Tue, 6 Jan 2015 19:01:39 +0100
Message-ID: <CAKXHbyPPiiqN_e5kgOb36gLeTR+b==8ZXQbNUrnKGCbDzqxLaw@mail.gmail.com> (sfid-20150106_190204_540376_6E3643AB)
Subject: Re: [PATCH] net: wireless: b43legacy: radio.c: Remove unused function
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Network Development <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-01-05 7:34 GMT+01:00 Rafał Miłecki <zajec5@gmail.com>:
> On 3 January 2015 at 13:28, Rickard Strandqvist
> <rickard_strandqvist@spectrumdigital.se> wrote:
>> 2015-01-02 22:34 GMT+01:00 Rafał Miłecki <zajec5@gmail.com>:
>>>
>>> 1) I gave you Ack for the changes
>>> 2) You could drop "net: wireless: " or better use something Sedat proposed
>>
>> Nice, yes I miss the Ack :)
>>
>> I just got one more complaining about my subject-line in "net: wireless: "
>> I use some sed call for this, so it's easy to fix. I will now remove that
>> part hereinafter.
>
> Will you re-send this patch with a proper subject then, please?
>
> --
> Rafał


Hi Rafał

Ok, resent the patch.

Just a thought about this naming.
Now I have changed in radio.c and radio.h, what happens when I send
another patch for other files in the same directory, the caption will
then be identical.


Kind regards
Rickard Strandqvist
