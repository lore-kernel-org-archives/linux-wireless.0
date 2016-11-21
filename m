Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55806 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751870AbcKUHHd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 02:07:33 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Nishant Sarmukadam" <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: RE: Problems getting mwifiex with sd8887 to work
Date: Mon, 21 Nov 2016 07:07:26 +0000
Message-ID: <915ae2d7b20d455d86a574c562dfd5fe@SC-EXCH04.marvell.com> (sfid-20161121_080736_867411_28112DDE)
References: <20161110175915.GB1585@katana>
 <507fff29bd2048c2b2295beb451943b5@SC-EXCH04.marvell.com>
 <20161113141348.GA32086@katana>
In-Reply-To: <20161113141348.GA32086@katana>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wolfram,

> From: Wolfram Sang [mailto:wsa@the-dreams.de]
> Sent: Sunday, November 13, 2016 7:44 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Nishant Sarmukadam; Kalle Valo
> Subject: Re: Problems getting mwifiex with sd8887 to work
> 
> > 0x242 command failure is expected for sd8887, as It's not supported.
> 
> Is the same true for 0x10f?
> 
> mwifiex_sdio mmc2:0001:1: CMD_RESP: cmd 0x10f error, result=0x2
> 
> Otherwise I can connect to the network and run performance tests now.

Error code 2 from firmware is unsupported command. You can ignore this and earlier 
error seen for 0x242 command. They aren't harmful.

Regards,
Amitkumar
