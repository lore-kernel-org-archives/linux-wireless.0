Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2469 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab1JMS2J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 14:28:09 -0400
Message-ID: <4E972D85.6070000@broadcom.com> (sfid-20111013_202812_833030_5EDE1CF2)
Date: Thu, 13 Oct 2011 20:27:17 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Alwin Beukers" <alwin@broadcom.com>
Subject: Re: [PATCH 22/22] brcm80211: removed file wifi.c
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
 <1318445492-24207-23-git-send-email-arend@broadcom.com>
 <CAB=NE6XYFB4uWcRR1kSNKLaJC4W1E3uLZOd3hGEArjzsmNG4PQ@mail.gmail.com>
 <4E96A696.9040607@broadcom.com>
 <CAB=NE6XiXc=TsjQ0bCphqaprDAjrXMfoKaQTwyNu-hX2d0issA@mail.gmail.com>
In-Reply-To: <CAB=NE6XiXc=TsjQ0bCphqaprDAjrXMfoKaQTwyNu-hX2d0issA@mail.gmail.com>
Content-Type: multipart/signed;
 boundary=------------enig0C72CEA48B5111ED75849E80;
 micalg=pgp-sha1;
 protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--------------enig0C72CEA48B5111ED75849E80
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/13/2011 08:08 PM, Luis R. Rodriguez wrote:
> On Thu, Oct 13, 2011 at 1:51 AM, Arend van Spriel <arend@broadcom.com> =
wrote:
>> On 10/12/2011 11:54 PM, Luis R. Rodriguez wrote:
>>> On Wed, Oct 12, 2011 at 11:51 AM, Arend van Spriel <arend@broadcom.co=
m> wrote:
>>>> From: Alwin Beukers <alwin@broadcom.com>
>>>>
>>>> Wifi.c was empty after previous cleanups, so it was removed.
>>>>
>>>> Reviewed-by: Arend van Spriel <arend@broadcom.com>
>>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>>
>>> Heh, remove Reviewed-by dude.
>>>
>>>   Luis
>>>
>>
>> I had a remark on this in earlier commits. So I am clearly missing the=

>> point here. The author submitted this change and others for review to =
me
>> and I reviewed it as requested. Hence the Reviewed-by: entry.
>>
>> I have been given the task to publish these patches and I sign them of=
f
>> for the "Developer's Certificate of Origin". Hence the Signed-off-by: =
entry.
>>
>> Is there something wrong with this reasoning?
>=20
> Yeah this all makes no sense. If someone submits you a patch for you
> to review *and* push upstream you simply add *their* SOB first, and
> then after that your own.
>=20
>   Luis
>=20

Ok, dude

Not trying to be rude, but in my opinion these are two separate things.
Your statement is that Signed-off-by: entry also covers the "Reviewer's
statement of oversight", but I could not find any confirmation to your
statement in the SubmittingPatches documentation.

The only miss I see is that the author did not sign off on this patch.

Gr. AvS


--------------enig0C72CEA48B5111ED75849E80
Content-Type: application/pgp-signature;
 name=signature.asc
Content-Description: OpenPGP digital signature
Content-Disposition: attachment;
 filename=signature.asc
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOly2IAAoJELcEx/G14aEWmh0P/3+9gKVY1pWNU/PVypd2eosT
17/aOU0UZvXC6MOK+cwstuYO/DpCLnKalLlppNmK79PLA4jGg30RmoghnXcEjAnn
UvZAvBJ9Dh9bbxJnajrpDYRrYWcjB3vsf3RGxNHA9/1DO8fBvIsJRTZwfpgJJoym
1Hm8WnmRY46dtSuXQ7VUv6qPoE2519z/125eLUK/CRAQI0Y8dbhe0zWXNSt/Hc7R
C7TwpijlzySQeHSKRYpfj0NhsYYSoqDqOf8xwLZJyRJvv6gvlw3g+j17MWpgYlUB
lHj7Q9uOrKfciSF5EpUQDIPNSlz9POLB9WlyoEPByI4EPqUkD1C8q2yRATg5Si6m
Ts9bhnGxMiLR1VEidjFcWBI7pi5FySIXQzuNbVJpKOFk7vRCyx4ImP0VFKglngvR
R4MPTcSV/Rv8XtWOM1jlLGymA0Wt6faAP451dYh4YStsC+EmsUKAUKrTuFLwWhid
agtzINxkTHYl8PHbjHKjTlirDC6KRQiY5gZb3I9mU3bTL0Hug/Fb8P9iSbU7dwlL
XcXFapwTGRnPf/eDmjCAc8v8/T2tSXfgq4Cy/OmubbGo7yEf2oHOdnbKPGUneOd8
pNWqGfSe3X+mMx0FakzOrUzNPRXM+ejBq5WJ6B85EojJO5wdWkgG8ZwPsma+FznU
9xsLSrIEgNQKRuCbuxfU
=O4SZ
-----END PGP SIGNATURE-----

--------------enig0C72CEA48B5111ED75849E80--

