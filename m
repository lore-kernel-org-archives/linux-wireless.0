Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:51990 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZDJFN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 01:13:59 -0400
Received: by ewy9 with SMTP id 9so1000252ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 09 Apr 2009 22:13:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49DED22E.4000001@lwfinger.net>
References: <49DE1638.8060906@lwfinger.net> <873achunwz.fsf@litku.valot.fi>
	 <49DED22E.4000001@lwfinger.net>
Date: Fri, 10 Apr 2009 07:13:56 +0200
Message-ID: <2d0a357f0904092213m124305adu5eddc25ccd2b6591@mail.gmail.com> (sfid-20090410_071404_047982_82786BFF)
Subject: Re: Another regression in 2.6.30-rc1
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

I think it is a good choice to put informations about regressions in
Linus-tree in a separate Email as you did for wireless-tesing ML.
I reported about ACPI-battery issue [1] already, but I think it
"disappeared" in the flood of replies.

Kind Regards,
Sedat

[1] http://marc.info/?l=3Dlinux-wireless&m=3D123919839513697&w=3D2

On Fri, Apr 10, 2009 at 6:59 AM, Larry Finger <Larry.Finger@lwfinger.ne=
t> wrote:
> Kalle Valo wrote:
>>
>> Thanks Larry, this was very helpful. After cherry picking this commi=
t
>> wireless-testing is booting without errors for me.
>>
>> In general sharing regressions and workarounds in this list is a ver=
y
>> good idea. I'm sure most of the people (including me) don't have tim=
e to
>> follow lkml and find fixes for all regressions.
>
> I make a point of following Linus's tree quite closely during the mer=
ge process
> so that the number of rebuilds is not too large when I do a bisection=
=2E For some
> reason, the stuff that comes in just before -rc1 seems to have the mo=
st
> problems. I had 3 regressions from the last two batches of commits. F=
ortunately,
> I only had to bisect two of them, but it was interesting while findin=
g the
> third. At every kernel build I had to test whether the patches for th=
e other 2
> cases needed to be installed. The 3rd regression and one of the other=
s were from
> successive commits! Murphy rules.
>
> When I know of unfixed problems in the wireless-testing tree, I will =
certainly
> continue to post whatever info I have, just as I rely on the members =
of this
> list when I have a problem.
>
> Larry
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
