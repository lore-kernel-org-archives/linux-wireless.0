Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:53628 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932177AbeDCMjQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 08:39:16 -0400
From: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
        Amarnath Hullur Subramanyam <amarnath@qti.qualcomm.com>,
        Rajesh Chauhan <rajeshc@qti.qualcomm.com>
Subject: Wi-Fi Disconnection on Suspend for no wowlan triggers 
Date: Tue, 3 Apr 2018 12:39:11 +0000
Message-ID: <0663e93cc5ca45e6b7191760414b1189@aphydexm01f.ap.qualcomm.com> (sfid-20180403_143933_219854_7488B497)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All ,

I would like to discuss on the commit 8125696991194aacb1173b6e8196d19098b44=
e17 (cfg80211/mac80211: disconnect on suspend) which triggers the STA disco=
nnection on suspend if no wowlan triggers are registered.
I guess the intention here is to disconnect from the AP if the device canno=
t wake up on a packet / not configured with wowlan triggers .=20
Can this behavior get enhanced to only do so on driver's preference -  do a=
 disconnect for only the host drivers that would want to do so (through an =
additional feature capability) ?

Regards,
Sunil
=20
