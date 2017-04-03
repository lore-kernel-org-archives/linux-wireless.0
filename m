Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28892 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbdDCTaa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 15:30:30 -0400
From: qca_dlansky <qca_dlansky@qualcomm.com>
To: David Binderman <dcb314@hotmail.com>,
        qca_merez <qca_merez@qca.qualcomm.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: linux-4.11-rc5/drivers/net/wireless/ath/wil6210/pmc.c: 2 * poor
 place for limits check ?
Date: Mon, 3 Apr 2017 19:30:23 +0000
Message-ID: <d2d7047c4e7b4931b77a82aaf43e2abb@euamsexm01b.eu.qualcomm.com> (sfid-20170403_213039_135506_8B3CDF72)
References: <HE1PR0801MB1865948355B11C9E63315D2F9C080@HE1PR0801MB1865.eurprd08.prod.outlook.com>
In-Reply-To: <HE1PR0801MB1865948355B11C9E63315D2F9C080@HE1PR0801MB1865.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Binderman [mailto:dcb314@hotmail.com]=20
Sent: Monday, April 3, 2017 2:16 PM

>
> Hello there,
>
> 1.
>
> linux-4.11-rc5/drivers/net/wireless/ath/wil6210/pmc.c:188]: (style) Array=
 index 'i' is used before limits check.

Thanks for letting us know.
We'll upload a fix soon.

Thanks,
 Dedy.
