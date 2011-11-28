Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38972 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1K1L1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 06:27:44 -0500
Received: by wwp14 with SMTP id 14so8911291wwp.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 03:27:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201111261939.10769.pawel.sikora@agmk.net>
References: <201111261939.10769.pawel.sikora@agmk.net>
Date: Mon, 28 Nov 2011 16:57:43 +0530
Message-ID: <CAD2nsn0VPBCF=ycoo7ke1zAPNpLqKbueJiqbztV+wpXJKZdntA@mail.gmail.com> (sfid-20111128_122749_778084_B3153E05)
Subject: Re: ath9k module not fully operating.
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pawel.sikora@agmk.net>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Peter Stuge <peter@stuge.se>
Content-Type: multipart/mixed; boundary=f46d04182642914aa104b2c9ca38
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d04182642914aa104b2c9ca38
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2011/11/27 Pawe=C5=82 Sikora <pawel.sikora@agmk.net>:
> Hi,
>
> i have an asus laptop with following atheros wireless adapter:
>
> 03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless N=
etwork Adapter (PCI-Express) (rev 01)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Subsystem: AzureWave AW-NB037H 802.11bgn Wirel=
ess Half-size Mini PCIe Card [AR9002WB-1NGCD]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: bus master, fast devsel, latency 0, IRQ=
 17
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Memory at ddc00000 (64-bit, non-prefetchable) =
[size=3D64K]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [40] Power Management version 3
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [50] MSI: Enable- Count=3D1/1 Ma=
skable- 64bit-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [60] Express Legacy Endpoint, MS=
I 00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [100] Advanced Error Reporting
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [140] Virtual Channel
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [160] Device Serial Number 00-15=
-17-ff-ff-24-14-12
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Capabilities: [170] Power Budgeting <?>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Kernel driver in use: ath9k
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Kernel modules: ath9k
>
> during latop startup the "wireless" led is turned off, kernel with udev l=
oad ath9k module
>
> [ =C2=A0 =C2=A09.070238] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, =
low) -> IRQ 17
> [ =C2=A0 =C2=A09.070257] ath9k 0000:03:00.0: setting latency timer to 64
> [ =C2=A0 =C2=A09.081908] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 =
(level, low) -> IRQ 22
> [ =C2=A0 =C2=A09.082056] snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
> [ =C2=A0 =C2=A09.082241] snd_hda_intel 0000:00:1b.0: setting latency time=
r to 64
> [ =C2=A0 =C2=A09.083643] input: Asus WMI hotkeys as /devices/platform/asu=
s-nb-wmi/input/input6
> [ =C2=A0 =C2=A09.119760] ath: EEPROM regdomain: 0x60
> [ =C2=A0 =C2=A09.119764] ath: EEPROM indicates we should expect a direct =
regpair map
> [ =C2=A0 =C2=A09.119768] ath: Country alpha2 being used: 00
> [ =C2=A0 =C2=A09.119771] ath: Regpair used: 0x60
> [ =C2=A0 =C2=A09.131566] usb 2-1: new high speed USB device number 2 usin=
g ehci_hcd
> [ =C2=A0 =C2=A09.238212] asus_wmi: Backlight controlled by ACPI video dri=
ver
> [ =C2=A0 =C2=A09.239078] ieee80211 phy0: Selected rate control algorithm =
'ath9k_rate_control'
> [ =C2=A0 =C2=A09.241745] Registered led device: ath9k-phy0
> [ =C2=A0 =C2=A09.241756] ieee80211 phy0: Atheros AR9285 Rev:2 mem=3D0xfff=
fc90001860000, irq=3D17
>
> but the wpa_supplicant daemon finally can't establish link with accesspoi=
nt (reports rf-kill? error).
> manual wireless enabling (Fn key + F2 key) fixes wpa_supplicant problems.
> it looks like the ath9k module doesn't enable some hardware parts on syst=
em startup / laptop resume.
> i've tested this issue with 3.1.2 and 3.2.0-rc3 git kernel sources.

i will just try to recreate this issue, once i get access to Asus
laptop.  there is no issues with external PCI extender + AR9285.
also please let us know if its AR9285 is working properly in some
previous builds.
also follow up with Peter Stuge's comments.  apart from what Peter had
mentioned the only other thing i can think of is rfkill polarity for
you card may be '1'(while default is '0'). you can get this info with
the attached debug patch.


>
> BR,
> Pawe=C5=82.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>



--=20
shafi

--f46d04182642914aa104b2c9ca38
Content-Type: text/x-diff; charset=US-ASCII; name="rfkill-debug.patch"
Content-Disposition: attachment; filename="rfkill-debug.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gvje7tfb0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9ody5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2h3LmMKaW5kZXggNjYyYWI3ZS4uODE2ZTkwYSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2h3LmMKKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2h3LmMKQEAgLTIyMTIsMTIgKzIyMTIsMTQgQEAgaW50
IGF0aDlrX2h3X2ZpbGxfY2FwX2luZm8oc3RydWN0IGF0aF9odyAqYWgpCiAJfQogCiAjaWYgZGVm
aW5lZChDT05GSUdfUkZLSUxMKSB8fCBkZWZpbmVkKENPTkZJR19SRktJTExfTU9EVUxFKQorCQlw
cmludGsoIlxucmZzaWxlbnQgPSAldSIsIGFoLT5yZnNpbGVudCk7CiAJYWgtPnJmc2lsZW50ID0g
YWgtPmVlcF9vcHMtPmdldF9lZXByb20oYWgsIEVFUF9SRl9TSUxFTlQpOwogCWlmIChhaC0+cmZz
aWxlbnQgJiBFRVBfUkZTSUxFTlRfRU5BQkxFRCkgewogCQlhaC0+cmZraWxsX2dwaW8gPQogCQkJ
TVMoYWgtPnJmc2lsZW50LCBFRVBfUkZTSUxFTlRfR1BJT19TRUwpOwogCQlhaC0+cmZraWxsX3Bv
bGFyaXR5ID0KIAkJCU1TKGFoLT5yZnNpbGVudCwgRUVQX1JGU0lMRU5UX1BPTEFSSVRZKTsKKwkJ
cHJpbnRrKCJcbnJma2lsbF9wb2xhcml0eSA9ICV1IiwgYWgtPnJma2lsbF9wb2xhcml0eSk7CiAK
IAkJcENhcC0+aHdfY2FwcyB8PSBBVEg5S19IV19DQVBfUkZTSUxFTlQ7CiAJfQo=
--f46d04182642914aa104b2c9ca38--
