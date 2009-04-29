Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:56230 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbZD2Qsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 12:48:37 -0400
Received: by bwz7 with SMTP id 7so1292218bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2009 09:48:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090428155244.GD4113@tuxdriver.com>
References: <20090416002220.GA4138@makis> <20090424040143.GB3277@hash.localnet>
	 <20090428155244.GD4113@tuxdriver.com>
Date: Wed, 29 Apr 2009 19:48:35 +0300
Message-ID: <40f31dec0904290948x4becb1fu3187dd4c4e7e089@mail.gmail.com> (sfid-20090429_184841_992114_14106ECF)
Subject: Re: [ath5k-devel] [PATCH 1/7] ath5k: Allow user/driver to set txpower
From: Nick Kossifidis <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/28 John W. Linville <linville@tuxdriver.com>:
> On Fri, Apr 24, 2009 at 12:01:43AM -0400, Bob Copeland wrote:
>> On Thu, Apr 16, 2009 at 03:22:20AM +0300, Nick Kossifidis wrote:
>> > =C2=A0* Now that we have regulatory control enable the driver to s=
et txpower on hw
>> > =C2=A0* Also use txpower table offset so that we can match power r=
ange set by user/driver with indices on power table.
>>
>> BTW I gave this patchset a spin on my rf 5413 and it works fine here=
,
>> so feel free to add my Acked-By on the series. =C2=A0Does it need an=
ything
>> besides a reposting with 72-col changelogs?
>
> The series seems fine, but I was waiting for a repost with the
> narrower changelogs...?
>
> John

Is this really needed ? I'm full right now ;-(
Can anyone else resend this plz ?



--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
