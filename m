Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:42564 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932082AbeCINei (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 08:34:38 -0500
Subject: Re: [PATCH] drivers: net: wireless: ath: ath9k: dfs: remove VLA usage
To: Andreas Christoforou <andreaschristofo@gmail.com>,
        keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1520601833-4952-1-git-send-email-andreaschristofo@gmail.com>
From: Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fb0bb0e5-e037-e006-ca11-45eb8a8aa1b7@gmail.com> (sfid-20180309_143456_605155_1B75CE22)
Date: Fri, 9 Mar 2018 05:34:36 -0800
MIME-Version: 1.0
In-Reply-To: <1520601833-4952-1-git-send-email-andreaschristofo@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/09/2018 05:23 AM, Andreas Christoforou wrote:
> The kernel would like to have all stack VLA usage removed.
> 
> This is the correct patch.
> 
> Signed-off-by: Andreas Christoforou <andreaschristofo@gmail.com>

This is a lazy changelog really.

'This is the correct patch' has no technical value.

What is VLA  ? Sure, _now_ its pretty clear since we have floods of 
these patches, but...

In one or two years, people reading it will not understand the logic of 
this patch.

I had to look at the source to understand what was going on, and that is 
not a good sign for a trivial patch like that.
