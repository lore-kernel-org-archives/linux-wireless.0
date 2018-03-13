Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36006 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752914AbeCMQkG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 12:40:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v9,1/8] rsi: add rx control block to handle rx packets in USB
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1519741578-12640-2-git-send-email-amitkarwar@gmail.com>
References: <1519741578-12640-2-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-bluetooth@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20180313164006.381A060390@smtp.codeaurora.org> (sfid-20180313_174030_536174_E20AF6B8)
Date: Tue, 13 Mar 2018 16:40:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> 
> Rx bluetooth endpoint shall be added in further patches. Rx control
> block is introduced here to handle Rx packets properly. Separate
> function is written to initialize the RX control blocks.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

8 patches applied to wireless-drivers-next.git, thanks.

1100f81bbcd1 rsi: add rx control block to handle rx packets in USB
a4302bff28e2 rsi: add bluetooth rx endpoint
4c10d56a76bb rsi: add header file rsi_91x
2108df3c4b18 rsi: add coex support
38aa4da50483 Bluetooth: btrsi: add new rsi bluetooth driver
716b840c7641 rsi: handle BT traffic in driver
898b25533931 rsi: add module parameter operating mode
681805b1401b rsi: sdio changes to support BT

-- 
https://patchwork.kernel.org/patch/10245547/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
