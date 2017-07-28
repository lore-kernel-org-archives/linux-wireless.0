Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38132 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752091AbdG1O1G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:27:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,01/17] rsi: add common structures needed for command packets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1499690448-9956-2-git-send-email-amitkarwar@gmail.com>
References: <1499690448-9956-2-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20170728142706.0B189609FD@smtp.codeaurora.org> (sfid-20170728_162710_774574_D290BFF1)
Date: Fri, 28 Jul 2017 14:27:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> 
> All internal management packets (command packets) use some common
> fields and some packet specific fields for packet descriptors.
> This patch adds some common structures which are needed for all
> command packets.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

17 patches applied to wireless-drivers-next.git, thanks.

6c8ab76d6ae9 rsi: add common structures needed for command packets
9a629fafe7d8 rsi: immediate wakeup bit and priority for TX command packets
6abdf2c19346 rsi: Update in tx command frame radio capabilities
dff80fc5fe4f rsi: remove unnecessary check for 802.11 management packet
59e006dc77c4 rsi: Update peer notify command frame
3a9828c92ba1 rsi: Update aggregation parameters command frame
5c7ca1bbf200 rsi: Update baseband RF programming frame
f04854fa3c38 rsi: update set_channel command frame
de1d1813a8ca rsi: update vap capabilities command frame
a84faab0fdb6 rsi: update set_key command frame
2a58900bf59d rsi: set_key enhancements
b3115e8a4267 rsi: update autorate request command frame
bcb283d27f65 rsi: block/unblock data queues as per connection status
79e590d924de rsi: update tx command frame block/unblock data
5059afacee88 rsi: Remove internal header from Tx status skb
86583258499c rsi: Send rx filter frame to device when interface is down
d7203a83f065 rsi: regulatory enhancements

-- 
https://patchwork.kernel.org/patch/9832877/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
