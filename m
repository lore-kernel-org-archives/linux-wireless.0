Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35105 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbeCTSyv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 14:54:51 -0400
Received: by mail-it0-f65.google.com with SMTP id v194-v6so3722792itb.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2018 11:54:50 -0700 (PDT)
Subject: Re: [PATCH v3 19/20] firmware: add request_firmware_cache() to help
 with cache on reboot
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Joe Perches <joe@perches.com>, Takashi Iwai <tiwai@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jikos@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: akpm@linux-foundation.org, cantabile.desu@gmail.com,
        kubakici@wp.pl, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        Abhay_Salunke@dell.com, bjorn.andersson@linaro.org,
        jewalt@lgsinnovations.com, oneukum@suse.com, ast@fb.com,
        andresx7@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20180310141501.2214-1-mcgrof@kernel.org>
 <20180310141501.2214-20-mcgrof@kernel.org> <20180320083055.GA21640@kroah.com>
 <20180320173409.GD4449@wotan.suse.de> <20180320173801.GA25040@kroah.com>
 <20180320182409.GF4449@wotan.suse.de>
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Message-ID: <5dc49c7f-56f6-28df-38da-bfa998afbdbb@linuxfoundation.org> (sfid-20180320_195504_883233_5963A525)
Date: Tue, 20 Mar 2018 14:54:44 -0400
MIME-Version: 1.0
In-Reply-To: <20180320182409.GF4449@wotan.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dZnBsK6zJZIXdswTT4134XOJDdG4uDARv"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dZnBsK6zJZIXdswTT4134XOJDdG4uDARv
Content-Type: multipart/mixed; boundary="ky4SFbjlcXhHbJVEhY0MFmRXRqaODFEgR";
 protected-headers="v1"
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Julia Lawall <julia.lawall@lip6.fr>, Nicolas Palix <nicolas.palix@imag.fr>,
 Joe Perches <joe@perches.com>, Takashi Iwai <tiwai@suse.de>,
 Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jikos@kernel.org>,
 Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: akpm@linux-foundation.org, cantabile.desu@gmail.com, kubakici@wp.pl,
 linux-wireless@vger.kernel.org, keescook@chromium.org, shuah@kernel.org,
 mfuzzey@parkeon.com, zohar@linux.vnet.ibm.com, dhowells@redhat.com,
 pali.rohar@gmail.com, arend.vanspriel@broadcom.com, zajec5@gmail.com,
 nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org,
 dmitry.torokhov@gmail.com, dwmw2@infradead.org, Abhay_Salunke@dell.com,
 bjorn.andersson@linaro.org, jewalt@lgsinnovations.com, oneukum@suse.com,
 ast@fb.com, andresx7@gmail.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Message-ID: <5dc49c7f-56f6-28df-38da-bfa998afbdbb@linuxfoundation.org>
Subject: Re: [PATCH v3 19/20] firmware: add request_firmware_cache() to help
 with cache on reboot
References: <20180310141501.2214-1-mcgrof@kernel.org>
 <20180310141501.2214-20-mcgrof@kernel.org> <20180320083055.GA21640@kroah.com>
 <20180320173409.GD4449@wotan.suse.de> <20180320173801.GA25040@kroah.com>
 <20180320182409.GF4449@wotan.suse.de>
In-Reply-To: <20180320182409.GF4449@wotan.suse.de>

--ky4SFbjlcXhHbJVEhY0MFmRXRqaODFEgR
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 03/20/18 14:24, Luis R. Rodriguez wrote:
> *Iff* this seems sensible, this would only mean kernel.org would have t=
o start
> accepting git notes long term, for those who optionally want to push th=
em or
> fetch them.

We don't disallow them. You just need to make sure you're fetching and
pushing them, because they aren't by default. You can set this in your
kernel.org origin section of .git/config:

[remote origin]
  ...
  fetch =3D +refs/notes/*:refs/notes/*

And then push them separately as "git push origin refs/notes/*".

Since frontends clone with --mirror, the notes will be available on all
git.kernel.org nodes (e.g. see
https://git.kernel.org/mricon/hook-test/c/a8d310d4c13)

If you do start using notes, I strongly suggest you pick a dedicated
refspace for it instead of putting things into the default
refs/notes/commits, e.g.:

git notes --ref crosstree [...]

This will create refs/notes/crosstree that has less of a chance to be
clobbered by someone else's use of notes.

Best,
--=20
Konstantin Ryabitsev
Director, IT Infrastructure Security
The Linux Foundation


--ky4SFbjlcXhHbJVEhY0MFmRXRqaODFEgR--

--dZnBsK6zJZIXdswTT4134XOJDdG4uDARv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQR2vl2yUnHhSB5njDW2xBzjVmSZbAUCWrFY9AAKCRC2xBzjVmSZ
bNmiAP9UuzzjLaSnoK7TU9GXgJ0myKjzw2rSZm3czpzrMvVLMAD6AlX9DZNGUl0+
M0RQvBkxMoekEXswcP5TEcoi3UDAFQo=
=O/vz
-----END PGP SIGNATURE-----

--dZnBsK6zJZIXdswTT4134XOJDdG4uDARv--
