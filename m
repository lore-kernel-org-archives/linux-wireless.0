Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([74.201.84.155]:29103 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbbAZDJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 22:09:50 -0500
References: <1422099243-20321-1-git-send-email-hong@topbug.net> <CA+icZUWtwQoBxWu+LSgva4sKgx1dLgAvxNXWxu2QN0s1zm-tWQ@mail.gmail.com>
From: Hong Xu <hong@topbug.net>
To: sedat.dilek@gmail.com
Cc: wireless <linux-wireless@vger.kernel.org>, kvalo@codeaurora.org
Subject: Re: [PATCH v4] ath9k and ath9k_htc: rename variable "led_blink"
In-reply-to: <CA+icZUWtwQoBxWu+LSgva4sKgx1dLgAvxNXWxu2QN0s1zm-tWQ@mail.gmail.com>
Date: Sun, 25 Jan 2015 19:09:41 -0800
Message-ID: <87k30ack5m.fsf@home.hong.me> (sfid-20150126_040953_207356_3F35EE4A)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain


Sedat Dilek <sedat.dilek@gmail.com> writes:

> On Sat, Jan 24, 2015 at 12:34 PM, Hong Xu <hong@topbug.net> wrote:
>> ath9k and ath9k_htc use the variable name "led_blink" to indicate
>> whether the module parameter "blink" is on. This name is easy to
>> conflict with other variables, and has caused a compiler error found
>> by kbuild test bot. The compiler error is as following:
>>
>> drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple definition of `led_blink'
>> drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x20): first defined here
>>
>> Fixes: 3a939a671225 ("ath9k_htc: Add a module parameter to disable blink")
>> Reported-by: kbuild test robot <fengguang.wu@intel.com>
>> Signed-off-by: Hong Xu <hong@topbug.net>
>> ---
>> Compared to previous versions, the commit message is improved to fit
>> the contribution guideline (again).
>> ---
>
> This looks good.
> ( As said please have a look at [1]. )
>
> I have one thing for followers of (linux-wireless) mailing-lists in general.
> If your patch is against a special Git tree, please add a
> "subject-prefix" and/or put a note in the commit-body.
> For example: "This patch is against wireless-drivers-next or
> linux-next (next-2015-01-23)."
> This is very helpful.
> Think also of patches listed and downloadable from patchwork-service [2].
>
> $ git format-patch --subject-prefix="PATCH wireless-drivers-next" ...
>
> ( Maybe w-d-n or w-d-next is a good abbreviation :-). )
>
> - Sedat -
>
> [1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches
> [2] https://patchwork.kernel.org/project/linux-wireless/list/

Thanks, Sedat. I'll be more careful next time :)

Hong

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUxa/1AAoJECZsfTOCL4R4Z0wP/jstwZ+S2hksImQgHeCItgwh
4qAOmRapEN5gHW+AiPq3XoscbHM75i/2qj6lwwOS4shPE8+CruWhVggvpolM4sGv
TYuuQundJS0BJdKO+rJEpj2pSmzJ9vfFoBcPvHKG/6vQfCNbFJPgFgw6vmYxMOMY
tQM53Qm+V5V73l+1OzRFEpV0EjkM6Y3lpV3LFkCufQqjDULlWWsfw4xfE24CsY+i
0Er2GEaKns3xSVR+X6Ztvkopd/Ra4Ugm+EXMBiz1nssjaxNWk+GPR4h02wo13mSO
r3HfOCqBRt8EZvd9lv9t0bkF5UMHkTNhxr2IOFHMYgHvIod58OC3qG6QT5VHoTtx
m5vEUPtb93QoAMZ07T/qBaVb1otILGiaCW92ZMulw/DPbszd5ls+GINY5zOgRLRl
5GbH0ZJgA15smoXJcHKRTRrKzstRtizY7wGT6/zsxOtSE+HUwo0RJpYcSpQnEG3L
PQ2f484k3B9eYIPNP3SznoNCg3FdfBKLcVkfvZLzg6fgAXoScypM98bCqMZ8o4Ij
syERgSMc2Gcj6q6u1IcmdkuuaqPqFO0+mwp0IZEzhDjhuDqKXtIUkKU10vM5G3sl
zfINSG3/iB9phLdS6VtNMQ0dJoPTfRKL7AQp2n2KuebSjDJclvF9U3dwuTgQRpAT
J5rU3xHruIhx3saE0rD4
=IuUD
-----END PGP SIGNATURE-----
--=-=-=--

