Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55272 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753030AbdF0O07 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 10:26:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [PATCH 00/17] rsi: station enhancements
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
Date: Tue, 27 Jun 2017 17:26:44 +0300
In-Reply-To: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
        (Amitkumar Karwar's message of "Fri, 23 Jun 2017 19:37:19 +0530")
Message-ID: <87h8z1bj6j.fsf@codeaurora.org> (sfid-20170627_162724_996488_2FD816BA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> We have internal management frames(commands) sent to firmware for
> various configurations. This patch defines some common structures
> which can be shared by those frames. Key handling and regulatory
> enhancements are also includesd. With this patch series included,
> station can connect to security enabled AP and send/receive data.

Are you saying that before rsi driver was not able to connect a security
enabled AP? Just trying to understand the status.

> Prameela Rani Garnepudi (17):
>   rsi: add common structures needed for command packets
>   rsi: immediate wakeup bit and priority for TX command packets
>   rsi: Update in tx command frame radio capabilities
>   rsi: remove unnecessary check for 802.11 management packet
>   rsi: Update peer notify command frame
>   rsi: Update aggregation parameters command frame
>   rsi: Update baseband RF programming frame
>   rsi: update set_channel command frame
>   rsi: update vap capabilities command frame
>   rsi: update set_key command frame
>   rsi: set_key enhancements
>   rsi: update autorate request command frame
>   rsi: block/unblock data queues as per connection status
>   rsi: update tx command frame block/unblock data
>   rsi: Remove internal header from Tx status skb
>   rsi: Send rx filter frame to device when interface is down
>   rsi: regulatory enhancements

Also in the future please try to keep the size of patchsets in
reasonable sizes. Something like max 10-12 patches per set is usually
ok, dependinging on the size of patches of course. But anything more
than that and the review becomes too annoying.

-- 
Kalle Valo
