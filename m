Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from le-vert.net ([81.56.196.209]:37355 "EHLO mail.le-vert.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbYIQLPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 07:15:52 -0400
Message-ID: <48D0E463.70008@le-vert.net> (sfid-20080917_131556_499860_AC6500AC)
Date: Wed, 17 Sep 2008 13:05:07 +0200
From: =?ISO-8859-1?Q?=22Adam_C=E9cile_=28Le=5FVert=29=22?=
	<gandalf@le-vert.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jochen Friedrich <jochen@scram.de>, linux-wireless@vger.kernel.org,
	499246-quiet@bugs.debian.org
Subject: Re: iw packaging
References: <1221596962.9262.12.camel@johannes.berg>	 <48D0DEF0.2060407@scram.de> <1221648205.9262.48.camel@johannes.berg>
In-Reply-To: <1221648205.9262.48.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

I'm aware of this issue. It has been done to have a fully working=20
aircrack-ng for lenny release.
I'll package iw seperatly once lenny has been released.

Regards, Adam.

Johannes Berg a =E9crit :
> On Wed, 2008-09-17 at 12:41 +0200, Jochen Friedrich wrote:
>  =20
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Johannes Berg schrieb:
>>
>>    =20
>>> I've just tagged iw version 0.9 (and 0.9.1 after a small build fix)
>>> because I think the tool is now actually usable in a limited way, u=
nlike
>>> before where it would never properly report errors etc.
>>>
>>> Anyone want to pick it up for the various distros?
>>>      =20
>> In Debian, iw seems to be already packaged as part of aircrack-ng wh=
ich now needs
>> to be packaged seperately.
>>    =20
>
> Yeah, it's also a pre-release version that the aircrack developers ar=
e
> distributing. I'm not very happy with that and have filed a bug again=
st
> aircrack-ng (but it seems to not have gone through yet)
>
> johannes
>  =20

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
