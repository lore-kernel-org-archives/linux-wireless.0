Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:62309 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaABT05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 14:26:57 -0500
Received: by mail-wg0-f53.google.com with SMTP id k14so12625208wgh.8
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jan 2014 11:26:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5ce9ab14-5794-4c0d-a859-7a158655f58e@googlegroups.com>
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com>
 <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com>
 <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com>
 <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com>
 <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com>
 <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com>
 <52BD68BA.3080304@broadcom.com> <CAGb2v67Q=q4vyOftb+BLhAYR-6d04dDP3+kY3b88U8_vCvAmgQ@mail.gmail.com>
 <52C570B6.30500@broadcom.com> <CAGb2v650WNnXqRY+PTwqjbo7pBPDvwHEfzvLM6HaLakZ4Nt1JA@mail.gmail.com>
 <5ce9ab14-5794-4c0d-a859-7a158655f58e@googlegroups.com>
From: Michal Suchanek <hramrach@gmail.com>
Date: Thu, 2 Jan 2014 20:26:16 +0100
Message-ID: <CAOMqctTs7VrQVqO50Pa0GF87UF46OrsWAtMW54Gy61Ef8_vn7Q@mail.gmail.com> (sfid-20140102_202701_572505_E824B8EE)
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Olliver Schinagl <oliver+list@schinagl.nl>, benn@cubietech.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 January 2014 20:22, Rosimildo DaSilva <rosimildo@gmail.com> wrote:
> It would be nice to be precise about what is working:
>
> a) Wifi + BT
> b) WIFI only
> c) BT only
>
> Reading the thread, it seems you got (a) WIFI + BT working. Is this correct

No, it's b)

There is some bit missing for BT. Possibly setting the power and reset
gpio pins correctly. Or maybe the uart is set up with wrong
parameters.

Thanks

Michal
