Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44506 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934058AbeAXPph (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:45:37 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtl8xxxu: Fix trailing semicolon
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180117105622.3717-1-luisbg@kernel.org>
References: <20180117105622.3717-1-luisbg@kernel.org>
To: Luis de Bethencourt <luisbg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Luis de Bethencourt <luisbg@kernel.org>
Message-Id: <20180124154537.1BE29607EB@smtp.codeaurora.org> (sfid-20180124_164621_802640_A488E313)
Date: Wed, 24 Jan 2018 15:45:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis de Bethencourt <luisbg@kernel.org> wrote:

> The trailing semicolon is an empty statement that does no operation.
> Removing it since it doesn't do anything.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
> Acked-by: Jes Sorensen <Jes.Sorensen@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

8054a275de08 rtl8xxxu: Fix trailing semicolon

-- 
https://patchwork.kernel.org/patch/10169063/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
