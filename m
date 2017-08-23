Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38926 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbdHWENu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 00:13:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] drivers: net: wireless: atmel: check memory allocation failure
References: <1503389481-4988-1-git-send-email-himanshujha199640@gmail.com>
Date: Wed, 23 Aug 2017 07:13:43 +0300
In-Reply-To: <1503389481-4988-1-git-send-email-himanshujha199640@gmail.com>
        (Himanshu Jha's message of "Tue, 22 Aug 2017 13:41:21 +0530")
Message-ID: <87efs2yl8o.fsf@kamboji.qca.qualcomm.com> (sfid-20170823_061410_991166_12375603)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Himanshu Jha <himanshujha199640@gmail.com> writes:

> Check memory allocation failure and return -ENOMEM if failure
> occurs.
>
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>

The title prefix is wrong:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
Kalle Valo
