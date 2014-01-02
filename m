Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:33584 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaABVDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 16:03:55 -0500
Message-ID: <52C5D438.9050909@broadcom.com> (sfid-20140102_220359_114109_20DD2E32)
Date: Thu, 2 Jan 2014 22:03:52 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: linux-sunxi <linux-sunxi@googlegroups.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Olliver Schinagl <oliver+list@schinagl.nl>,
	<benn@cubietech.com>
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com> <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com> <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com> <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com> <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com> <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com> <52BD68BA.3080304@broadcom.com> <CAGb2v67Q=q4vyOftb+BLhAYR-6d04dDP3+kY3b88U8_vCvAmgQ@mail.gmail.com> <52C570B6.30500@broadcom.com> <CAGb2v650WNnXqRY+PTwqjbo7pBPDvwHEfzvLM6HaLakZ4Nt1JA@mail.gmail.com>
In-Reply-To: <CAGb2v650WNnXqRY+PTwqjbo7pBPDvwHEfzvLM6HaLakZ4Nt1JA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/2014 06:09 PM, Chen-Yu Tsai wrote:
> Hi,
> 
> On Thu, Jan 2, 2014 at 9:59 PM, Arend van Spriel <arend@broadcom.com> wrote:
> [snip]
>> Hi Chen-Yu,
>>
>> I confirmed the patch is working with a revision 0 of the device. What
>> chip revision does it give in your log (need to load brcmfmac with
>> module parameter debug=4).
> 
> Mine is revision 1. Managed mode confirmed working.

Which firmware did you use. Can you provide 'hexdump -C' output
(especially the last part).

Gr. AvS

> Logs:
> brcmfmac: F1 signature read @0x18000000=0x1591a962
> brcmfmac: brcmf_sdio_chip_recognition chipid=0xa962 chiprev=1
> brcmfmac: brcmf_sdio_chip_buscoresetup ccrev=39, pmurev=13, buscore
> rev/type=10/0x829
> 
> 
> ChenYu
> 

