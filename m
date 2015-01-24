Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59469 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbAXLKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 06:10:32 -0500
Received: by mail-pd0-f178.google.com with SMTP id y10so2759683pdj.9
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2015 03:10:31 -0800 (PST)
References: <1422094745-12718-1-git-send-email-hong@topbug.net> <87k30ciiir.fsf@kamboji.qca.qualcomm.com> <CA+icZUVq-bhryv=Aj7JuCzFU6kTQEh+jiwBR_bnJzNnjJ2Kg-A@mail.gmail.com>
From: Hong Xu <hong@topbug.net>
To: sedat.dilek@gmail.com
Cc: Kalle Valo <kvalo@codeaurora.org>,
	wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k and ath9k_htc: rename variable "led_blink"
In-reply-to: <CA+icZUVq-bhryv=Aj7JuCzFU6kTQEh+jiwBR_bnJzNnjJ2Kg-A@mail.gmail.com>
Date: Sat, 24 Jan 2015 03:10:23 -0800
Message-ID: <87twzgmo2o.fsf@home.hong.me> (sfid-20150124_121038_251721_7034B2AA)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain


Sedat Dilek <sedat.dilek@gmail.com> writes:

> On Sat, Jan 24, 2015 at 11:23 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Hong Xu <hong@topbug.net> writes:
>>
>>> ath9k and ath9k_htc use the variable name "led_blink" to indicate
>>> whether the module parameter "blink" is on. This name is easy to
>>> conflict with other variables, thus they are renamed.
>>
>> Please state clearly that this fixes a compiler error found by kbuild.
>> Also it's very much recommended to add the actual compiler error to the
>> commit log:
>>
>> drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple definition of `led_blink'
>> drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x20): first defined here
>>
>
> Some more things...
>
> If you post a vN (referring to your v3) of a patch, please add a
> history of changes.
>
> 2nd, use the Fixes tag [2] in this case with a reference to the
> culprit commit [1].
>
> Fixes: 3a939a671225 ("ath9k_htc: Add a module parameter to disable blink")
>
> Last but not least, honour credits like Reported-by/Tested-by (plus
> some infos like broken in Linux-next $VERSION).
>
Thanks for your comments, I should have been more careful with the
guideline. I guess we shouldn't credit kbuild for reporting in this case?

Hong

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUw32fAAoJECZsfTOCL4R4tpcQAI1RPkdZWO1SrtqvXhXP8YUB
97ZRGL1/1pFiAu+1WGm94PQHC7X8L6Jv2e7iRCIfSqKQmjBpBqVMJUpvnGMF/S6n
P09a+7mqk2rPafKa6aLt8cHgQG7GLigHpv/1qEy8ag/G3PbYdFpdiiQZbmI/BfRB
H2dM1HBaP1YhdxF2ONpb6OTS506IQ5si79t4lUitmnTrRS0i0xC6QrBGaKq8G+Ql
P7oAwEyRtOAV/dcqbPwfcMBD1eDc/iTfrH5MxcMdVgqwe8+qaHCIOJzidqp/JR7u
NGUBneDeYETG/t5XRkbhIjJH16wy5D+iRZi9nbaZ4r+w3ohOss8uwTkTyb3OGmzK
1DTrKI8PYka/VG5jWRIuim1w+8y8W8sxa9ymuPRaqbf4k4I4vlFwOzxrNGu3VIR/
EvAYR75pJHBc1zV82Y+yGfUG7XQIMVlPewaFF9wSyypXiZRh5advq/zpvyHTBxxt
EwqGcJB3zb2AGgMH5/sXPZPWTd9Rw6lx+xUcxOH2ysSXND743pW5OvKbFa0rF4ZG
+rR4inrJojb2giqMr1QGG8kn82QN2d3q6/TOnmqWBraKNiBqhOFOdflypUEVjpwh
aEE3UeTv6CnBlOVlKUyI7eJlpeg5YsUiGGNdNM/JQquHWMj82D3+QBuxF71Np3x2
sivnr4TqPo70RD1Hf+mE
=nBCV
-----END PGP SIGNATURE-----
--=-=-=--
