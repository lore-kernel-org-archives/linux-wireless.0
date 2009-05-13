Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47697 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZEMOGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 10:06:24 -0400
Received: by ewy24 with SMTP id 24so797458ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 07:06:23 -0700 (PDT)
Cc: linux-wireless@vger.kernel.org
Message-Id: <E9323507-2720-4F87-A666-6CB61C084F9B@freebsd.org>
From: Rui Paulo <rpaulo@freebsd.org>
To: Dan Williams <dcbw@redhat.com>
In-Reply-To: <1242221616.11182.4.camel@localhost.localdomain>
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-2--224110211"
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: Interop testing of 802.11s
Date: Wed, 13 May 2009 15:06:18 +0100
References: <64642731-8767-4063-9479-E6F2E5222EB6@freebsd.org> <1242221616.11182.4.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-2--224110211
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On 13 May 2009, at 14:33, Dan Williams wrote:

> On Tue, 2009-05-12 at 23:57 +0100, Rui Paulo wrote:
>> Hi,
>> I'm developing the 11s stack for FreeBSD and I'm looking for folks
>> interested in doing interop testing. I've already noticed some things
>> that don't cope with the latest draft that I would like to discuss in
>> further detail.
>
> The CozyBit guys were the original authors of the 802.11s stack and  
> have
> usually been pretty on top of the latest draft stuff.  javier@cozybit
> (dot com) or luisca@cozybit (dot com) are the people who have been  
> most
> heavily involved in it.

Thanks. I've contacted them.

> Any chance you could point out the issues you've found just so others
> are aware of them?


I believe more recent drafts have changed some small things, namely  
OUIs and IEs.

Regards,
--
Rui Paulo


--Apple-Mail-2--224110211
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Darwin)

iEYEARECAAYFAkoK09oACgkQfD8M/ASTygLrXACgxDqWm77vYHpD5GNPjAlr4fX1
d3YAoJpTwY4cmHfb/ZydSB+c6792Cq2t
=mfX0
-----END PGP SIGNATURE-----

--Apple-Mail-2--224110211--
