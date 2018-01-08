Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37046 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932282AbeAHPqz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 10:46:55 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rt2x00: Delete an error message for a failed memory allocation in
 rt2x00queue_allocate()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <cdeaa8a2-06bb-10e9-05d7-f531c00eef5d@users.sourceforge.net>
References: <cdeaa8a2-06bb-10e9-05d7-f531c00eef5d@users.sourceforge.net>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-Id: <20180108154654.7975660215@smtp.codeaurora.org> (sfid-20180108_164720_016621_4BC03794)
Date: Mon,  8 Jan 2018 15:46:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SF Markus Elfring <elfring@users.sourceforge.net> wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 29 Dec 2017 22:11:42 +0100
> 
> Omit an extra message for a memory allocation failure in this function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

cd7c0cdab7ff rt2x00: Delete an error message for a failed memory allocation in rt2x00queue_allocate()

-- 
https://patchwork.kernel.org/patch/10137399/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
