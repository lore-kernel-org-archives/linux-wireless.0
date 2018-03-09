Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0112.outbound.protection.outlook.com ([104.47.1.112]:11447
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751227AbeCIQ3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 11:29:08 -0500
From: Deronne Sebastien <S.Deronne@televic.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k: rx trigger issue
Date: Fri, 9 Mar 2018 16:29:06 +0000
Message-ID: <AM3PR07MB37011815CBF8E2429415760F5DE0@AM3PR07MB370.eurprd07.prod.outlook.com> (sfid-20180309_172912_342061_8BB69BA8)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am facing an issue with ath9k.
I noticed that the rx_tasklet is not being triggered right after reception =
of a packet.
Instead, it is triggered much later (up to few milliseconds) and forwards u=
p more than one packets (all packets received during this time interval).
How can I get a trigger for each received packet instead of a trigger for a=
 burst of packets?

Kind regards,
S=E9bastien Deronne.
