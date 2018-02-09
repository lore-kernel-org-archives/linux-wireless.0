Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34866 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbeBIIBO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 03:01:14 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Timothy Redaelli <tredaelli@redhat.com>
Cc: <linux-wireless@vger.kernel.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath9k: fix DFS detector synchronization
References: <c967cb589b7d71a17afc29f3c634f961ef6820dd.1518090407.git.tredaelli@redhat.com>
Date: Fri, 09 Feb 2018 10:01:09 +0200
In-Reply-To: <c967cb589b7d71a17afc29f3c634f961ef6820dd.1518090407.git.tredaelli@redhat.com>
        (Timothy Redaelli's message of "Thu, 8 Feb 2018 12:46:47 +0100")
Message-ID: <87fu6aegmy.fsf@kamboji.qca.qualcomm.com> (sfid-20180209_090117_738839_42F75B08)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Timothy Redaelli <tredaelli@redhat.com> writes:

> The code currently syncronize the DFS region only if curchan != 0, but hostapd
> launch DFS before the channel is set and so set_dfs_domain is never executed.
>
> CC: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Timothy Redaelli <tredaelli@redhat.com>

What kind of bug does this fix? Please describe the symptoms from user's
point of view.

-- 
Kalle Valo
