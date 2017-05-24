Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46996 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940340AbdEXNrV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 09:47:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ssb: Delete an error message for a failed memory allocation in
 ssb_devices_register()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <b8db3326-5f45-04c0-a6c3-d5183d602e8d@users.sourceforge.net>
References: <b8db3326-5f45-04c0-a6c3-d5183d602e8d@users.sourceforge.net>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
Message-Id: <20170524134721.3D33D60711@smtp.codeaurora.org> (sfid-20170524_154929_184316_B81DB704)
Date: Wed, 24 May 2017 13:47:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SF Markus Elfring <elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 17 May 2017 18:12:16 +0200
> 
> Omit an extra message for a memory allocation failure in this function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> Acked-by: Michael Büsch <m@bues.ch>

Patch applied to wireless-drivers-next.git, thanks.

c6c092dcb21e ssb: Delete an error message for a failed memory allocation in ssb_devices_register()

-- 
https://patchwork.kernel.org/patch/9731583/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
