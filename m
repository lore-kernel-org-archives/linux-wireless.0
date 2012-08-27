Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51594 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab2H0JPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 05:15:37 -0400
Received: by obbuo13 with SMTP id uo13so7677397obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2012 02:15:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120827065419.GB22073@ritirata.org>
References: <1346014505-7554-1-git-send-email-ordex@autistici.org>
	<CAD2nsn16-uZ0CbBXrHjUS2Rwn53OYNrLvjujmPAwGDCEbdYJxg@mail.gmail.com>
	<20120827065419.GB22073@ritirata.org>
Date: Mon, 27 Aug 2012 14:45:36 +0530
Message-ID: <CAD2nsn2CYYP2+VRX0Ph=6Vw2kTqmwRvMn+FVeS3FwMd=jvwy8Q@mail.gmail.com> (sfid-20120827_111541_684991_DE6471E5)
Subject: Re: [PATCHv2 1/2] ath9k_htc: remove driver specific checks for
 interfaces combinations
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Antonio,

>
> On Mon, Aug 27, 2012 at 10:47:29 +0530, Mohammed Shafi wrote:
>> Hi,
>>
>> On Mon, Aug 27, 2012 at 2:25 AM, Antonio Quartulli <ordex@autistici.org> wrote:
>> > Thanks to the new interface combinations code we can safely remove all the
>> > driver specific checks for unsupported modes.
>>
>> i had just sent this some time back
>> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/96443.
>>
>> please review if something had to be changed.
>>
>
> Sorry, but I hadn't seen your patch. Otherwise I would have not sent mine.

no issues :-)

>
> Your patch is ok. But, at this point, should patch 2/6 and 3/6 be merged
> together?

an order of interface combinations advertisement(2/6), followed by
removing specific
checks should be fine right ?

>
> Other than that, patch 2/6 should be modified to take into account IBSS mode.

yeah saw your patch, that in ath9k_htc IBSS interface can coexist with
one more interface.
The standalone limitation exists in ath9k too, not sure this is a
limitation to beacon config
for ath9k & ath9k_htc, I will just confirm. If its fine i will resend
the v2 version signing off both
of our names accounting IBSS mode too.


>
>
> Cheers,
>
>
> --
> Antonio Quartulli
>
> ..each of us alone is worth nothing..
> Ernesto "Che" Guevara



-- 
thanks,
shafi
