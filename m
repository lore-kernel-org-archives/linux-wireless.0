Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40434 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdHHLpJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:45:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: bcma: make BCMA a menuconfig to ease disabling it all
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170417100730.3648-2-vincent.legoll@gmail.com>
References: <20170417100730.3648-2-vincent.legoll@gmail.com>
To: Vincent Legoll <vincent.legoll@gmail.com>
Cc: linux-kernel@vger.kernel.org, zajec5@gmail.com,
        linux-wireless@vger.kernel.org,
        Vincent Legoll <vincent.legoll@gmail.com>
Message-Id: <20170808114508.E4E4360300@smtp.codeaurora.org> (sfid-20170808_134526_826795_526B1C76)
Date: Tue,  8 Aug 2017 11:45:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vincent Legoll <vincent.legoll@gmail.com> wrote:

> No need to get into the submenu to disable all BCMA-related config entries.
> 
> Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

9ca766b3641f bcma: make BCMA a menuconfig to ease disabling it all

-- 
https://patchwork.kernel.org/patch/9683685/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
