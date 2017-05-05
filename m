Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0084.outbound.protection.outlook.com ([104.47.1.84]:48568
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751788AbdEEMFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 08:05:12 -0400
From: Bassem BOUBAKER <bassem.boubaker@actia.fr>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Problem with mwifiex: Can not set Tx data rate in disconnected state
Date: Fri, 5 May 2017 12:05:10 +0000
Message-ID: <AM2PR01MB10253CB1097CC91096B31E9B9CEB0@AM2PR01MB1025.eurprd01.prod.exchangelabs.com> (sfid-20170505_140621_791185_BF0C9BC5)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

I'm facing some issues with mwifiex when trying to establish a wifi  direct=
 connection (p2p) between my board and my phone (an android).
My connman commands are:


# connmanctl
connmanctl> enable p2p
Enabled p2p
connmanctl> agent on
Agent registered
connmanctl> scan p2p


These commands seem to be passing just fine as I'm able to see my board app=
ears in the available wifi direct list on my phone.
When accepting the connection from connman side with the commands below:


connmanctl> scan p2p
Agent RequestPeerAuthorization peer_XXXX
Accept connection (yes/no)? yes


I got this error: connmanctl> mwifiex_sdio mmc0:0001:1: Can not set Tx data=
 rate in disconnected state


I have this configuration:
Kernel version: 3.10
connman version: 1.34
mwifiex: backports-mwifiex_4.1.1



Any ideas what may be causing this?

Thanks.
