Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36083 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbZCXXOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 19:14:52 -0400
Received: by fxm2 with SMTP id 2so2517578fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 16:14:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090324202633.GA21202@drd1813.lan>
References: <20090324202633.GA21202@drd1813.lan>
Date: Wed, 25 Mar 2009 00:14:34 +0100
Message-ID: <69e28c910903241614s5502a7ffoe85bba0515b8c223@mail.gmail.com> (sfid-20090325_001511_028544_30268FFC)
Subject: Re: ar9170 - Cace Airpcap NX
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <gst@remote-exploit.org>
To: Mike Kershaw <dragorn@kismetwireless.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 9:26 PM, Mike Kershaw
<dragorn@kismetwireless.net> wrote:
> The Cace Airpcap NX device is an atheros 9170 USB device (sold with c=
ustom
> windows drivers for rfmon in windows).
>
> Works fine once the USB device id is added to ar9170, device 0xCACE,0=
x0300
>
> -m
>
> --
> Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
> GPG Fingerprint: 3546 89DF 3C9D ED80 3381 =A0A661 D7B2 8822 738B BDB1
>
> Supercollider Programming: The art of debugging your program by
> letting it crash and looking at what remains.
>

On a related note, the Cace AirPcap N (PCI/Cardbus/PCIE) is an AR5008,
with the PCI ID CACE:0023 (PCI/Cardbus)/CACE:0024 (PCIE). Someone with
an AirPcap N should test if adding this ID to ath9k works.

-G=E1bor

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
