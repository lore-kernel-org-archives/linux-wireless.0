Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58170 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752997AbcICRCz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 13:02:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wl18xx: add time sync configuration api
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160824113527.5040-1-guym@ti.com>
To: Guy Mishol <guym@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Guy Mishol <guym@ti.com>
Message-Id: <20160903170254.CE18661831@smtp.codeaurora.org> (sfid-20160903_190258_636110_B6990CB7)
Date: Sat,  3 Sep 2016 17:02:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy Mishol <guym@ti.com> wrote:
> Add time sync configuration api.
> The new api allows to configure the synchronization
> mode (STA/AP/MESH) and (in case of Mesh mode) the
> master address of each zone.
> 
> Signed-off-by: Guy Mishol <guym@ti.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

c5aa9541818a wl18xx: add time sync configuration api

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9297563/
