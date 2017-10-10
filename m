Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45082 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755634AbdJJIVj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 04:21:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: Random MAC address during scanning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1506682390-27716-1-git-send-email-gbhat@marvell.com>
References: <1506682390-27716-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Karthik Ananthapadmanabha <karthida@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20171010082139.024EC6079C@smtp.codeaurora.org> (sfid-20171010_102144_330302_C2C03617)
Date: Tue, 10 Oct 2017 08:21:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> From: Karthik Ananthapadmanabha <karthida@marvell.com>
> 
> Driver will advertise RANDOM_MAC support only if the device
> supports this feature.
> 
> Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

073a435d55a6 mwifiex: Random MAC address during scanning

-- 
https://patchwork.kernel.org/patch/9977525/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
