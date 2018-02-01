Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:41016 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbeBAEzA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 23:55:00 -0500
Received: by mail-yw0-f174.google.com with SMTP id b129so9470525ywa.8
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 20:55:00 -0800 (PST)
MIME-Version: 1.0
From: David Hutchison <dhutchison@bluemesh.net>
Date: Wed, 31 Jan 2018 21:54:59 -0700
Message-ID: <CA+i30h-rt18nnEnLt5YWD4HXek2nW2HcXZabCaqbLafaivRo9Q@mail.gmail.com> (sfid-20180201_055513_856620_4E6B37D4)
Subject: QCA9531 Question
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have two Atheros AP147 QCA9531 SoC, the radio is connected to the
WMAC. I am running OpenWRT Trunk on them and for some reason the TX/RX
is incredibly low.

The first AP147 is low powered, No xPA Bias and only has 20dB of
output power. Ath9k appears to run correctly, meaning I can bring up
station/AP. However when I scan, it see's nothing. When I bring up an
AP, the AP doesn't transmit.

The second AP147 has an xPA Bias level of 13. This time I can scan on
a station interface but everything it see's is incredibly low. The TX
Power is also very very low. With the xPA, this is supposed to run at
26 dB.

Is there a register a register that I can toggle to enable the QCA9531
internal PA/LNA? It's like ath9k is not enabling the internal PA/LNA
correctly.

The odd thing is, I have other QCA9531 boards ( Mikrotik based ) and
they run fine on OpenWRT Trunk. I'm not sure what the difference is...

Any insight would be much appreciated.

I posted some details on the LEDE forum:
https://forum.lede-project.org/t/ap147-010-qca9531-wmac-tx-power-issue/11126/2

-- Davey
