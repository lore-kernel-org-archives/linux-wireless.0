Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:36619 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdCQIqk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 04:46:40 -0400
Received: by mail-wr0-f179.google.com with SMTP id u108so47286202wrb.3
        for <linux-wireless@vger.kernel.org>; Fri, 17 Mar 2017 01:46:38 -0700 (PDT)
Received: from rainloop.xkonni.de (v22016114027340657.bestsrv.de. [37.120.174.147])
        by smtp.gmail.com with ESMTPSA id g6sm1830109wmc.30.2017.03.17.01.46.36
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Mar 2017 01:46:37 -0700 (PDT)
Mime-Version: 1.0
Date: Fri, 17 Mar 2017 08:46:36 +0000
Content-Type: text/plain; charset="utf-8"
Message-ID: <17d816d3dafddb3447e21808c130f596@rainloop.xkonni.de> (sfid-20170317_094653_204715_C0CA473E)
From: "Konstantin Koslowski" <konstantin.koslowski@gmail.com>
Subject: Dell DW1601 (WIL6210)
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear linux-wireless developers,=0A=0AI recently acquired a few Dell DW160=
1 cards and after a few initial searches it sounded like they could be us=
ed to connect to each other.=0ANow it seems that they do not have the wif=
i connectivity enabled, just WBE.=0A=0Arelevant lspci output:=0A03:00.0 P=
CI bridge [0604]: Wilocity Ltd. Wil6200 PCI Express Root Port [1ae9:0101]=
 (rev 04)=0A04:00.0 PCI bridge [0604]: Wilocity Ltd. Wil6200 PCI Express =
Port [1ae9:0200] (rev 04)=0A04:02.0 PCI bridge [0604]: Wilocity Ltd. Wil6=
200 Wireless PCI Express Port [1ae9:0201] (rev 14)=0A04:03.0 PCI bridge [=
0604]: Wilocity Ltd. Wil6200 Wireless PCI Express Port [1ae9:0201] (rev 1=
4)=0A05:00.0 Network controller [0280]: Qualcomm Atheros AR9462 Wireless =
Network Adapter [168c:0034] (rev 01)=0A=0ASo the wifi device does not sho=
w up. Seems it needs a different firmware.=0A=0AThe old linuxwireless wik=
i [http://linuxwireless.org/en/users/Drivers/wil6210/index.html] tells me=
 that I should contact Wilocity to get the wifi enabled firmware. As they=
 were bought by Qualcomm this is no longer possible,=0AThe current wiki j=
ust says: "We need to get this publicly available=E2=80=A6"=0A=0AIs there=
 any way to get this firmware and then flash it to the card/load it?=0A=
=0AThanks a lot!
