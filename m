Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44196 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759865AbdEXNnw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 09:43:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] iwlegacy: warn when enabling power save
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1494840506-16485-1-git-send-email-sgruszka@redhat.com>
References: <1494840506-16485-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-Id: <20170524134352.1A49B61272@smtp.codeaurora.org> (sfid-20170524_154408_477322_E6030F04)
Date: Wed, 24 May 2017 13:43:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> iwlegacy firmware can crash when power save is configured. PS was
> allowed in "dbdac2b iwlegacy: properly enable power saving" with belive
> that user who enable PS is aware of that and can relate firmware crahes
> with PS. However some distributions seems to enable PS without user
> intervention, so warn about that.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

438f3d13da5e iwlegacy: warn when enabling power save

-- 
https://patchwork.kernel.org/patch/9726579/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
