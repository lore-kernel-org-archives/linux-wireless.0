Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55773 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2DVFXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 01:23:08 -0400
Received: by wejx9 with SMTP id x9so6818258wej.19
        for <linux-wireless@vger.kernel.org>; Sat, 21 Apr 2012 22:23:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <146E772A-F387-4443-99C7-95C6B3BCE74C@gmail.com>
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com>
	<FC927BD3-30FD-4DF2-A65C-5BE785FB72BC@gmail.com>
	<CANUX_P0dR93vJicsrnpxPmOZvaxBvaONHQiFXOTcaP1Ax0LAnQ@mail.gmail.com>
	<816C5F70-E340-46F9-8206-2B230A27F3AD@gmail.com>
	<CANUX_P3=ttVKdLYBfAdGRhmfDRbPruogw8Eo_d09on0ajdTqUw@mail.gmail.com>
	<5714877C-2465-4FD5-94A0-9D0806A803C4@gmail.com>
	<CANUX_P27GoLY2q9jmsWw9Rzn9posf3mCjDa98+q4JP=83wYthg@mail.gmail.com>
	<8FBCAE90-FAE9-430D-888E-F055091E6683@gmail.com>
	<CANUX_P1OxH7rmYWxizEaf2DnPSTK0npNtZ2Q9Rm5dksnmFKD8g@mail.gmail.com>
	<9D52D4AD-58DC-4896-97FC-7248E1FD2614@gmail.com>
	<CANUX_P1ZX_e+0qs4sa7vdAqHvOQjO6+9PiFhDbW8ybE4ax80gQ@mail.gmail.com>
	<8EE08C44-8618-45EC-B890-B5B12B661FB6@gmail.com>
	<CANUX_P0O0-6sOaN59V_RxLj_DbiTdNdwq0zze6B6vMe1hfQuqA@mail.gmail.com>
	<37926591-261D-4C3E-A1D9-4A8AB3364F5D@gmail.com>
	<4F901224.1040508@sipsolutions.net>
	<EA757D90-2CCE-48A1-AF35-7F65EB45F7EE@gmail.com>
	<4F901F16.6080007@sipsolutions.net>
	<CAC79F14-24F2-4F90-8A47-B9B2744F5AE3@gmail.com>
	<CANUX_P2t86v0L=DDaaBdW-6Yb5ffSscv2aSy+jQ5dFc0TqWB_Q@mail.gmail.com>
	<D17CF50A-2CD7-427A-8159-A7857571823D@gmail.com>
	<CANUX_P1qCC63adSKHjHUcfufC0=QJLJz+Lqovk7ScHeE_hUuxg@mail.gmail.com>
	<146E772A-F387-4443-99C7-95C6B3BCE74C@gmail.com>
Date: Sun, 22 Apr 2012 08:23:06 +0300
Message-ID: <CANUX_P03Pz-Hi2dUhGq0W3spd0WNzk33EcK0baLh4Srrf0Vm1A@mail.gmail.com> (sfid-20120422_072313_887955_55C4C718)
Subject: Re: wlan0 not present
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dominik Feser <dominik.feser@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: multipart/mixed; boundary=f46d044287a66ed6ef04be3db71b
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d044287a66ed6ef04be3db71b
Content-Type: text/plain; charset=ISO-8859-1

>
> I downloaded the latest release from here:
> http://linuxwireless.org/en/users/Download/stable/ which is
> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.4/compat-wireless-3.4-rc3-1.tar.bz2

New patch attached.

--f46d044287a66ed6ef04be3db71b
Content-Type: text/x-patch; charset=US-ASCII; name="print.patch"
Content-Disposition: attachment; filename="print.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1brqyr00

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWRydi5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtZHJ2LmMKaW5kZXggNmYzMTJjNy4uYzQ1YWI4
NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtZHJ2LmMKKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtZHJ2LmMKQEAgLTE4MCw3ICsxODAs
NyBAQCBzdGF0aWMgaW50IGl3bF9yZXF1ZXN0X2Zpcm13YXJlKHN0cnVjdCBpd2xfZHJ2ICpkcnYs
IGJvb2wgZmlyc3QpCiAKIAlzcHJpbnRmKGRydi0+ZmlybXdhcmVfbmFtZSwgIiVzJXMlcyIsIG5h
bWVfcHJlLCB0YWcsICIudWNvZGUiKTsKIAotCUlXTF9ERUJVR19JTkZPKGRydiwgImF0dGVtcHRp
bmcgdG8gbG9hZCBmaXJtd2FyZSAlcyclcydcbiIsCisJZGV2X2VycihkcnYtPnNocmQtPnRyYW5z
LT5kZXYsICJhdHRlbXB0aW5nIHRvIGxvYWQgZmlybXdhcmUgJXMnJXMnXG4iLAogCQkgICAgICAg
KGRydi0+ZndfaW5kZXggPT0gVUNPREVfRVhQRVJJTUVOVEFMX0lOREVYKQogCQkJCT8gIkVYUEVS
SU1FTlRBTCAiIDogIiIsCiAJCSAgICAgICBkcnYtPmZpcm13YXJlX25hbWUpOwo=
--f46d044287a66ed6ef04be3db71b--
