Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n7.bullet.mud.yahoo.com ([216.252.100.58]:31583 "HELO
	n7.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751040AbYCKPOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 11:14:00 -0400
Message-ID: <47D6A1B4.8060603@yahoo.it> (sfid-20080311_151403_760960_2DE9D4FF)
Date: Tue, 11 Mar 2008 16:13:56 +0100
From: Filippo Zangheri <filippo.zangheri@yahoo.it>
MIME-Version: 1.0
To: Chris Hallinan <challinan@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Bug 1623
References: <c4aed99f0803100702h10d54260g22512d9d6bb850d2@mail.gmail.com>	 <1ba2fa240803100805o17d8239cm741891e5895dd07f@mail.gmail.com>	 <c4aed99f0803101650n69aaaac0n540f5acbc6dd554c@mail.gmail.com>	 <1ba2fa240803102317q6173e243nd7dff52fe83089f2@mail.gmail.com> <43e72e890803110803k5dae7300i94ff883c4dd5e9e9@mail.gmail.com>
In-Reply-To: <43e72e890803110803k5dae7300i94ff883c4dd5e9e9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez ha scritto:
> On Tue, Mar 11, 2008 at 2:17 AM, Tomas Winkler <tomasw@gmail.com> wro=
te:
>> On Tue, Mar 11, 2008 at 1:50 AM, Chris Hallinan <challinan@gmail.com=
> wrote:
>>  > On Mon, Mar 10, 2008 at 11:05 AM, Tomas Winkler <tomasw@gmail.com=
> wrote:
>>  >
>>  > > On Mon, Mar 10, 2008 at 4:02 PM, Chris Hallinan <challinan@gmai=
l.com> wrote:
>>  >  >  > http://bughost.org/bugzilla/show_bug.cgi?id=3D1623
>>  >  >  >
>>  >  >  >  Anything else I can do to help move this along?  I'd love =
to dive into
>>  >  >  >  the code, I just need a little guidance!  I've written and=
 debugged a
>>  >  >  >  few Linux drivers in my day...
>>  >  >  >
>>  >  >  >  Any other testing you need, I'd be happy to assist.
>>  >  >  >
>>  >  >  >  Thanks,
>>  >  >  >
>>  >  >  >  Chris
>>  >  >
>>  >  >  We've recently committed fixes to 4965 rate scaling can you t=
ry the
>>  >  >  latest version of wireless-testing kernel?
>>  >  >
>>  >  I was unable to get either 1.2.25 nor top-of-tree from git (iwlw=
ifi)
>>  >  to compile with wireless-testing kernel.
>>
>>  I see, the point is that wireless-testing already contains latest
>>  iwlwifi driver much newer then 1.2.25. so no need for patching just
>>  compile the kernel.
>=20
> Or if you don't want to compile your kernel and just compile the
> modules externally you can grab the compat-wireless-package that pull=
s
> daily from wireless-testing:
>=20
> http://linuxwireless.org/en/users/Download

I can confirm that. Building wireless drivers modules and subsystem
was never so easy and time-efficient.

Maybe this is useless, but if you want to avoid bulding all modules
and subsystems you just need to edit config.mk.

Great project!

Just my =E2=82=AC0.02.

--=20
=46ilippo Zangheri

GPG key ID: 0xE1D879FA
Key fingerprint: 816B CE57 D43C 0A47 EF35 3378 EA5F A72A E1D8 79FA
Key server: pgp.mit.edu

-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GE d- s+:- a-- C++ UL+++ P+ L+++ E-- W+ N* o-- K- w--- O-- M--
V- PS++ PE+ Y+ PGP++ t 5-- X++ R* tv b+ DI-- D---- G-- e++ h--
r++ z*
------END GEEK CODE BLOCK------

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
