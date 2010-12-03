Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.216.194]:59813 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0LCHXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 02:23:13 -0500
Received: by qyk4 with SMTP id 4so2799835qyk.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 23:23:12 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101203041109.GE2988@makis.mantri>
References: <20101203041109.GE2988@makis.mantri>
Date: Fri, 3 Dec 2010 08:23:12 +0100
Message-ID: <AANLkTin-mr1zRY8gxALLFnD6XHg1QEMPq90nXt=iuWkv@mail.gmail.com>
Subject: Re: [PATCH 5/6] ath5k: Update version string
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Content-Type: multipart/mixed; boundary=00163631020d3c1a3b04967c69d0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--00163631020d3c1a3b04967c69d0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 3, 2010 at 5:11 AM, Nick Kossifidis <mickflemm@gmail.com> wrote=
:
> =C2=A0* Change version number, we've added various new features lately.
> =C2=A0We need to find a way to maintain this, maybe on each kernel releas=
e
> =C2=A0or something. Also remove "EXPERIMENTAL", we aren't experimental an=
y
> =C2=A0more I think ;-)
>
> =C2=A0Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> ---
> =C2=A0drivers/net/wireless/ath/ath5k/base.c | =C2=A0 =C2=A02 +-
> =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless=
/ath/ath5k/base.c
> index 6edfa9f..835ab3a 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -78,7 +78,7 @@ MODULE_AUTHOR("Nick Kossifidis");
> =C2=A0MODULE_DESCRIPTION("Support for 5xxx series of Atheros 802.11 wirel=
ess LAN cards.");
> =C2=A0MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
> =C2=A0MODULE_LICENSE("Dual BSD/GPL");
> -MODULE_VERSION("0.6.0 (EXPERIMENTAL)");
> +MODULE_VERSION("0.7.0");
>
> =C2=A0static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_cha=
nnel *chan,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0bool skip_pcu);
>

Against linux-next (next-20101203) this patch needs a refresh (see attached=
 v2).
Guess you created your patchset from wireless-testing.

- Sedat -

--00163631020d3c1a3b04967c69d0
Content-Type: plain/text; name="5-6-ath5k-Update-version-string-v2.patch"
Content-Disposition: attachment;
	filename="5-6-ath5k-Update-version-string-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gh8qyu3r0

SW5kZXg6IGxpbnV4LW5leHQtMjAxMDEyMDMvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVr
L2Jhc2UuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC1uZXh0LTIwMTAxMjAzLm9yaWcvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYXRoL2F0aDVrL2Jhc2UuYworKysgbGludXgtbmV4dC0yMDEwMTIwMy9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNWsvYmFzZS5jCkBAIC03Niw3ICs3Niw3IEBACiBNT0RV
TEVfREVTQ1JJUFRJT04oIlN1cHBvcnQgZm9yIDV4eHggc2VyaWVzIG9mIEF0aGVyb3MgODAyLjEx
IHdpcmVsZXNzIExBTiBjYXJkcy4iKTsKIE1PRFVMRV9TVVBQT1JURURfREVWSUNFKCJBdGhlcm9z
IDV4eHggV0xBTiBjYXJkcyIpOwogTU9EVUxFX0xJQ0VOU0UoIkR1YWwgQlNEL0dQTCIpOwotTU9E
VUxFX1ZFUlNJT04oIjAuNi4wIChFWFBFUklNRU5UQUwpIik7CitNT0RVTEVfVkVSU0lPTigiMC43
LjAiKTsKIAogc3RhdGljIGludCBhdGg1a19pbml0KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KTsK
IHN0YXRpYyBpbnQgYXRoNWtfcmVzZXQoc3RydWN0IGF0aDVrX3NvZnRjICpzYywgc3RydWN0IGll
ZWU4MDIxMV9jaGFubmVsICpjaGFuLAo=
--00163631020d3c1a3b04967c69d0--
