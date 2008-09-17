Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from le-vert.net ([81.56.196.209]:37326 "EHLO mail.le-vert.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYIQLLT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 07:11:19 -0400
Message-ID: <48D0E5CE.8050401@le-vert.net> (sfid-20080917_131122_904260_398FDB9C)
Date: Wed, 17 Sep 2008 13:11:10 +0200
From: =?UTF-8?B?IkFkYW0gQ8OpY2lsZSAoTGVfVmVydCki?= <gandalf@le-vert.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jochen Friedrich <jochen@scram.de>, linux-wireless@vger.kernel.org,
	499246-quiet@bugs.debian.org
Subject: Re: iw packaging
References: <1221596962.9262.12.camel@johannes.berg>	 <48D0DEF0.2060407@scram.de> <1221648205.9262.48.camel@johannes.berg>	 <48D0E463.70008@le-vert.net> <1221649638.9262.50.camel@johannes.berg>
In-Reply-To: <1221649638.9262.50.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg a =C3=A9crit :
> On Wed, 2008-09-17 at 13:05 +0200, "Adam C=C3=A9cile (Le_Vert)" wrote=
:
>  =20
>> Hello Johannes,
>>
>> I'm aware of this issue. It has been done to have a fully working=20
>> aircrack-ng for lenny release.
>> I'll package iw seperatly once lenny has been released.
>>    =20
>
> Cool, thanks. Note that I think that one of the small command syntax
> changes I made might be breaking aircrack-ng, not sure how to handle
> that. They should've just used nl80211 directly if you ask me.
>
> johannes
>  =20
Why not having a talk with aircrack-ng main developper ?
I'm sure he would be happy to work with you and avoid having a patched=20
version of iw.

Thomas d'Otreppe: tdotreppe@aircrack-ng.org
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
