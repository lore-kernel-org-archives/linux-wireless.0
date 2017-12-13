Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pv43p53im-ztdg05051801.me.com ([17.139.149.167]:23720 "EHLO
        pv43p53im-ztdg05051801.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751882AbdLMIxn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 03:53:43 -0500
Content-type: text/plain; charset=utf-8
MIME-version: 1.0 (1.0)
Subject: Re: net/wireless/shipped-certs.c:2:1: error: expected expression at
 end of input
From: Damian Tometzki <damian.tometzki@icloud.com>
In-reply-to: <1512468219.26976.15.camel@sipsolutions.net>
Date: Wed, 13 Dec 2017 08:53:39 +0100
Cc: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <8617D3B1-DE6C-4E75-AB44-1845806E18D6@icloud.com> (sfid-20171213_095349_045433_E5E063A8)
References: <4006aefb-e9af-d809-b45a-201d20e75f9d@molgen.mpg.de>
 <1512468219.26976.15.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

I got. the same Build error.=20


VG Damian Tometzki





> Am 05.12.2017 um 11:03 schrieb Johannes Berg <johannes@sipsolutions.net>:
>=20
>> On Tue, 2017-12-05 at 11:01 +0100, Paul Menzel wrote:
>>=20
>>=20
>> ```
>> $ git describe
>> v4.15-rc2-79-gfd6d2e506ce6
>> $ git log --oneline -1
>> fd6d2e506ce6 Merge tag 'docs-4.15-fixes' of git://git.lwn.net/linux
>> $ time ARCH=3Di386 make deb-pkg -j50
>> [=E2=80=A6]
>> net/wireless/shipped-certs.c:2:1: error: expected expression at end of in=
put
>>  const u8 shipped_regdb_certs[] =3D {
>>  ^~~~~
>> [=E2=80=A6]
>> $ more net/wireless/shipped-certs.c
>> #include "reg.h"
>> const u8 shipped_regdb_certs[] =3D {
>> ```
>=20
> Ah, here we go - you probably don't have "hexdump" installed on this
> system?
>=20
> I thought about doing hexdump in posix shell/awk/sed/whatever
> instead... maybe I should do that.
>=20
> johannes
