Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43990 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753728AbeDSQPG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 12:15:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [02/10] wil6210: set/get EDMG channel through debugfs
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1523520526-24997-3-git-send-email-merez@codeaurora.org>
References: <1523520526-24997-3-git-send-email-merez@codeaurora.org>
To: Maya Erez <merez@codeaurora.org>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Message-Id: <20180419161506.868FA60A06@smtp.codeaurora.org> (sfid-20180419_181513_591413_62B97059)
Date: Thu, 19 Apr 2018 16:15:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <merez@codeaurora.org> wrote:

> Setting EDMG channel through debugfs for connect and PCP start
> commands.

Why? And what is an EDMG channel?

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_log_does_not_answer_why

I get bad vibes that this debugfs file is just a workaround for not adding this
to nl80211, a proper commit log would not give me such vibes in the first place :)

-- 
https://patchwork.kernel.org/patch/10338031/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
