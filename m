Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:45094 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaABRJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 12:09:33 -0500
Received: by mail-vb0-f53.google.com with SMTP id o19so7349511vbm.12
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jan 2014 09:09:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52C570B6.30500@broadcom.com>
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com>
 <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com>
 <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com>
 <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com>
 <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com>
 <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com>
 <52BD68BA.3080304@broadcom.com> <CAGb2v67Q=q4vyOftb+BLhAYR-6d04dDP3+kY3b88U8_vCvAmgQ@mail.gmail.com>
 <52C570B6.30500@broadcom.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 3 Jan 2014 01:09:12 +0800
Message-ID: <CAGb2v650WNnXqRY+PTwqjbo7pBPDvwHEfzvLM6HaLakZ4Nt1JA@mail.gmail.com> (sfid-20140102_181707_486111_1D7AF606)
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-sunxi <linux-sunxi@googlegroups.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Olliver Schinagl <oliver+list@schinagl.nl>, benn@cubietech.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Jan 2, 2014 at 9:59 PM, Arend van Spriel <arend@broadcom.com> wrote:
[snip]
> Hi Chen-Yu,
>
> I confirmed the patch is working with a revision 0 of the device. What
> chip revision does it give in your log (need to load brcmfmac with
> module parameter debug=4).

Mine is revision 1. Managed mode confirmed working.

Logs:
brcmfmac: F1 signature read @0x18000000=0x1591a962
brcmfmac: brcmf_sdio_chip_recognition chipid=0xa962 chiprev=1
brcmfmac: brcmf_sdio_chip_buscoresetup ccrev=39, pmurev=13, buscore
rev/type=10/0x829


ChenYu
