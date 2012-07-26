Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54985 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2GZF0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 01:26:23 -0400
Received: by obbuo13 with SMTP id uo13so2177888obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 22:26:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAT9HsgXHe-0qZ5vTvCuU8QZ006MrsCyu7Zc_PRFccz52TWcUw@mail.gmail.com>
References: <CAAT9HsjZ7wPbkRMH94HDNBS+vOhLigKLYULqfyQobh_Oyt9M4w@mail.gmail.com>
	<501030E9.3090707@lwfinger.net>
	<CAAT9Hshwb+iPMALGvP1P2UHzEQbyvYNM0_zz0dHp0mJuy6KwLA@mail.gmail.com>
	<50103BE8.1020203@lwfinger.net>
	<CAAT9HsjQ_tkm77NT_Rn5_Pi9BHGhY9Vz7jcVzkwdDUjUoKamtw@mail.gmail.com>
	<501061C8.5010108@lwfinger.net>
	<CA+XFjioVy_pmKxcJAe1U_M+zKNiiPEsb0bmkAfEWzmnnDBjLFw@mail.gmail.com>
	<CAAT9HsgXHe-0qZ5vTvCuU8QZ006MrsCyu7Zc_PRFccz52TWcUw@mail.gmail.com>
Date: Thu, 26 Jul 2012 10:56:22 +0530
Message-ID: <CAD2nsn2022_CbNtLCy64uFSMF=2PBMN4sDmO4pLbFodLQ139ZQ@mail.gmail.com> (sfid-20120726_072625_517469_9CA01437)
Subject: Re: New Laptop and Driver
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Tim and Alison Bentley <Home@trarbentley.net>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec54ee8cc09755204c5b4d643
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--bcaec54ee8cc09755204c5b4d643
Content-Type: text/plain; charset=ISO-8859-1

> Jul 26 05:58:23 tigger2 kernel: [ 1546.876477] cfg80211: Calling CRDA
> to update world regulatory domain
> Jul 26 05:58:23 tigger2 kernel: [ 1546.916447] cfg80211: World
> regulatory domain updated:
> Jul 26 05:58:23 tigger2 kernel: [ 1546.916450] cfg80211:   (start_freq
> - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> Jul 26 05:58:23 tigger2 kernel: [ 1546.916453] cfg80211:   (2402000
> KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> Jul 26 05:58:23 tigger2 kernel: [ 1546.916455] cfg80211:   (2457000
> KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> Jul 26 05:58:23 tigger2 kernel: [ 1546.916457] cfg80211:   (2474000
> KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> Jul 26 05:58:23 tigger2 kernel: [ 1546.916459] cfg80211:   (5170000
> KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> Jul 26 05:58:23 tigger2 kernel: [ 1546.916461] cfg80211:   (5735000
> KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> Jul 26 05:58:30 tigger2 kernel: [ 1553.767939] ath: phy0: Hardware
> device ID 0x0037 not supported
> Jul 26 05:58:30 tigger2 kernel: [ 1553.767948] ath9k 0000:03:00.0:
> Failed to initialize device
> Jul 26 05:58:30 tigger2 kernel: [ 1553.768137] ath9k: probe of
> 0000:03:00.0 failed with error -95

can you please try the attached dummy patch. see if the device is working.
if its a version of AR9485 it should work. if its properly working, we
can add a proper support.

>
>
> --
> Tim and Alison Bentley
> Home@TRARBentley.net
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi

--bcaec54ee8cc09755204c5b4d643
Content-Type: application/octet-stream; name="temp.patch"
Content-Disposition: attachment; filename="temp.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h53eg6d80

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9ody5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2h3LmMKaW5kZXggY2ZhOTFhYi4uNzMxMWNhOSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2h3LmMKKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2h3LmMKQEAgLTczMCw2ICs3MzAsNyBAQCBpbnQgYXRo
OWtfaHdfaW5pdChzdHJ1Y3QgYXRoX2h3ICphaCkKIAljYXNlIEFSOTMwMF9ERVZJRF9RQ0E5NTVY
OgogCWNhc2UgQVI5MzAwX0RFVklEX0FSOTU4MDoKIAljYXNlIEFSOTMwMF9ERVZJRF9BUjk0NjI6
CisJY2FzZSAweDM3OgogCQlicmVhazsKIAlkZWZhdWx0OgogCQlpZiAoY29tbW9uLT5idXNfb3Bz
LT5hdGhfYnVzX3R5cGUgPT0gQVRIX1VTQikKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2F0aC9hdGg5ay9wY2kuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9wY2ku
YwppbmRleCA4N2I4OWQ1Li5jYjNkOWQ2IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9hdGgvYXRoOWsvcGNpLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3Bj
aS5jCkBAIC0zNyw2ICszNyw3IEBAIHN0YXRpYyBERUZJTkVfUENJX0RFVklDRV9UQUJMRShhdGhf
cGNpX2lkX3RhYmxlKSA9IHsKIAl7IFBDSV9WREVWSUNFKEFUSEVST1MsIDB4MDAzMikgfSwgLyog
UENJLUUgIEFSOTQ4NSAqLwogCXsgUENJX1ZERVZJQ0UoQVRIRVJPUywgMHgwMDMzKSB9LCAvKiBQ
Q0ktRSAgQVI5NTgwICovCiAJeyBQQ0lfVkRFVklDRShBVEhFUk9TLCAweDAwMzQpIH0sIC8qIFBD
SS1FICBBUjk0NjIgKi8KKwl7IFBDSV9WREVWSUNFKEFUSEVST1MsIDB4MDAzNykgfSwgLyogUENJ
LUUgICA/ICAqLwogCXsgMCB9CiB9OwogCg==
--bcaec54ee8cc09755204c5b4d643--
