Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54768 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1FJQQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 12:16:49 -0400
Received: by qyg14 with SMTP id 14so1600949qyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 09:16:48 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Jun 2011 17:16:48 +0100
Message-ID: <BANLkTim3hO2zQGMqz0sZcN97nEki+OU87Q@mail.gmail.com> (sfid-20110610_181652_527886_2D40B78F)
Subject: Are features like Master Mode on intel 802.11n wireless NICs
 supported in the Linux driver?
From: "M. A." <jdiq123@googlemail.com>
To: ipw3945-devel@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I would be very grateful if some can advise on my previous email,
namely the features present in Intels 3x3 MIMO (450Mbps) chipsets,
namely (Ultimate N WiFi Link 5300 and 6300 NICs) and the features that
are currently supported by the iwlwifi/iwlang Linux driver.

In particular are any of these features supported:

1) Configuring the NIC as an AP (i.e. Master Mode via hostapd or otherwise).
2) STBC 3) Greenfield, 4) Short gaurd interval in 20/40Mhz,
4) Low-density parity check (LDPC) encoding, 5) Maximum likelihood
demodulation (MLD) and MRC,
6) Transmit beamforming (TxBF), 7) Ability to control
antenna-power/chain mask etc,
8) Support for HT IBSS/ad hoc speeds (Alexander's patch).
9) Per-Packet. Information (PPI)

 e.g. the output of "iw list" command of the cards would be very helpful.


I highly appreciate your help!
Thanks



On Thu, Jun 9, 2011 at 1:04 PM, M. A. <jdiq123@googlemail.com> wrote:
> Hi all,
>
> I would be very grateful if people can advise on the features present
> in Intels 3x3 MIMO (450Mbps) chipsets, namely (Ultimate N WiFi Link
> 5300 and 6300 NICs) and the features that are currently supported by
> the iwlwifi/iwlang Linux driver.
>
> e.g. the output of "iw list" command of the cards would be very helpful.
>
> For example does it support:
>
> 1) Configuring as an AP (via hostapd or otherwise).
> 2) STBC, 3) Greenfield, 4) Short gaurd interval, 4) Low-density parity
> check (LDPC) encoding, 5) Maximum likelihood demodulation (MLD) and
> MRC, 6) Transmit beamforming (TxBF), 7) Ability to control antenna-
> power/chain mask etc,
> 8) Support for HT IBSS/ad hoc speeds (Alexander's patch).
> 9) Per-Packet. Information (PPI) capturing
>
> Also to those who have tested these intel NICs, can you please provide
> a purchase recommendation as I intend to use it to run parameter
> specific tests (one at a time) via install these on around 5 laptops
> and similar platforms.
>
> Thank you all very much
>
