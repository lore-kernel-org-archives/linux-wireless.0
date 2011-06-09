Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65359 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab1FIMEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 08:04:12 -0400
Received: by ywe9 with SMTP id 9so726062ywe.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jun 2011 05:04:11 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Jun 2011 13:04:11 +0100
Message-ID: <BANLkTik=TGub=tEFC01bTrF_Erp5FT8C5w@mail.gmail.com> (sfid-20110609_140415_837344_C9F6ED6D)
Subject: Query regarding features and intel wireless NICs supported
From: "M. A." <jdiq123@googlemail.com>
To: ipw3945-devel@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I would be very grateful if people can advise on the features present
in Intels 3x3 MIMO (450Mbps) chipsets, namely (Ultimate N WiFi Link
5300 and 6300 NICs) and the features that are currently supported by
the iwlwifi/iwlang Linux driver.

e.g. the output of "iw list" command of the cards would be very helpful.

For example does it support:

1) Configuring as an AP (via hostapd or otherwise).
2) STBC, 3) Greenfield, 4) Short gaurd interval, 4) Low-density parity
check (LDPC) encoding, 5) Maximum likelihood demodulation (MLD) and
MRC, 6) Transmit beamforming (TxBF), 7) Ability to control antenna-
power/chain mask etc,
8) Support for HT IBSS/ad hoc speeds (Alexander's patch).
9) Per-Packet. Information (PPI) capturing

Also to those who have tested these intel NICs, can you please provide
a purchase recommendation as I intend to use it to run parameter
specific tests (one at a time) via install these on around 5 laptops
and similar platforms.

Thank you all very much
