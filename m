Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57451 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752804AbcICKJF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 06:09:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: fix missing break on IEEE80211_STYPE_ACTION case
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1471349413-21893-1-git-send-email-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20160903100844.CDF306201B@smtp.codeaurora.org> (sfid-20160903_120924_918603_D264F383)
Date: Sat,  3 Sep 2016 10:08:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The IEEE80211_STYPE_ACTION case is missing a break in the switch
> statement, causing it to fall through to the default case that
> reports a debug message about an unknown frame subtype. Fix this
> by adding in the missing break statement.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

d393be3ed0be mwifiex: fix missing break on IEEE80211_STYPE_ACTION case

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9283755/
