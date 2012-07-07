Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48075 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2GGKcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2012 06:32:12 -0400
Received: by obbuo13 with SMTP id uo13so16620630obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jul 2012 03:32:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn1-ZrKQxTYc_YZ6ETxovD9o7=Ygd2j2MxJiq8Vsiu19QQ@mail.gmail.com>
References: <20120706125043.GA23189@pandem0nium>
	<CAD2nsn1=PDBTRXumDh93DzvmFcBnyFeLD-5c5oSJmv3OO6LWGw@mail.gmail.com>
	<5244861.J1Tyef1FCX@bentobox>
	<4991617.K7XqcvhjBY@bentobox>
	<CAD2nsn2m1wizCw6WY-k0KRY2NJTaqqxdoA_d_+K-kqrhw+FZ3w@mail.gmail.com>
	<CAD2nsn1-ZrKQxTYc_YZ6ETxovD9o7=Ygd2j2MxJiq8Vsiu19QQ@mail.gmail.com>
Date: Sat, 7 Jul 2012 16:02:12 +0530
Message-ID: <CAD2nsn2_16KcE2g5gysc5XwVtns5jAwD+doRzqTQdsim8xbchQ@mail.gmail.com> (sfid-20120707_123216_426533_8F2E4E8E)
Subject: Re: ath9k: Problems with diversity on AR9330
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Sven Eckelmann <sven@narfation.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	ath9k-devel@lists.ath9k.org,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Content-Type: multipart/mixed; boundary=e89a8f5039cac4036504c43ae4e4
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--e89a8f5039cac4036504c43ae4e4
Content-Type: text/plain; charset=ISO-8859-1

> further i check with the CCK/DETECT and MC_GAIN_CTRL in ar9485, it  seems to be
>  ar9003_hw_ant_ctrl_apply CCK_DETECT 80be6788
>  ar9003_hw_ant_ctrl_apply MC_GAIN_CTRLL 13ef0200
> will check it out whats the one bit difference in CCK_DETECT

also could you provide the output of the attached patch, i would just
check the diversity
configuration


-- 
thanks,
shafi

--e89a8f5039cac4036504c43ae4e4
Content-Type: application/octet-stream; name="div-eep-dump.patch"
Content-Disposition: attachment; filename="div-eep-dump.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h4ck0eb50

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDNfZWVwcm9t
LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvYXI5MDAzX2VlcHJvbS5jCmluZGV4
IDJjZGY4MmIuLjU0MzAzODQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9h
dGg5ay9hcjkwMDNfZWVwcm9tLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlr
L2FyOTAwM19lZXByb20uYwpAQCAtMzYzMSw2ICszNjMxLDggQEAgc3RhdGljIHZvaWQgYXI5MDAz
X2h3X2FudF9jdHJsX2FwcGx5KHN0cnVjdCBhdGhfaHcgKmFoLCBib29sIGlzMmdoeikKIAogCWlm
IChBUl9TUkVWXzkzMzAoYWgpIHx8IEFSX1NSRVZfOTQ4NShhaCkpIHsKIAkJdmFsdWUgPSBhdGg5
a19od19hcjkzMDBfZ2V0X2VlcHJvbShhaCwgRUVQX0FOVF9ESVZfQ1RMMSk7CisKKwkJcHJpbnRr
KCJcbkFudGVubmEgRGl2ZXJzaXR5ICVzIEVFUF9BTlRfRElWX0NUTDEgJXgiLCBfX2Z1bmNfXywg
dmFsdWUpOwogCQkvKgogCQkgKiBtYWluX2xuYWNvbmYsIGFsdF9sbmFjb25mLCBtYWluX3RiLCBh
bHRfdGIKIAkJICogYXJlIHRoZSBmaWVsZHMgcHJlc2VudAo=
--e89a8f5039cac4036504c43ae4e4--
