Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40708 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937217AbdDZJEW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 05:04:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] rndis_wlan: add return value validation
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1492994428-16090-1-git-send-email-bianpan201603@163.com>
References: <1492994428-16090-1-git-send-email-bianpan201603@163.com>
To: Pan Bian <bianpan201603@163.com>
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Message-Id: <20170426090416.862BE6032C@smtp.codeaurora.org> (sfid-20170426_112859_277769_9DD16CE3)
Date: Wed, 26 Apr 2017 09:04:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pan Bian <bianpan201603@163.com> wrote:
> From: Pan Bian <bianpan2016@163.com>
> 
> Function create_singlethread_workqueue() will return a NULL pointer if
> there is no enough memory, and its return value should be validated
> before using. However, in function rndis_wlan_bind(), its return value
> is not checked. This may cause NULL dereference bugs. This patch fixes
> it.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Patch applied to wireless-drivers-next.git, thanks.

9dc7efd3978a rndis_wlan: add return value validation

-- 
https://patchwork.kernel.org/patch/9695387/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
