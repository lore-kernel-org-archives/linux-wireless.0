Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46284 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935700AbdEXNo7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 09:44:59 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: libertas: Remove function entry/exit debugging
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170515213317.GA45562@beast>
References: <20170515213317.GA45562@beast>
To: Kees Cook <keescook@chromium.org>
Cc: netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20170524134459.07E53602B8@smtp.codeaurora.org> (sfid-20170524_154547_896878_0D569867)
Date: Wed, 24 May 2017 13:44:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kees Cook <keescook@chromium.org> wrote:
> In at least one place, the enter/exit debugging was not being correctly
> matched. Based on mailing list feedback, it was desired to drop all of
> these in favor of using ftrace instead.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Suggested-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

4bc606af9fab libertas: Remove function entry/exit debugging

-- 
https://patchwork.kernel.org/patch/9728087/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
