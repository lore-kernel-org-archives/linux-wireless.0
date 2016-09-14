Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53896 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758731AbcINRAx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 13:00:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: correction in Rx STBC field of htcapinfo
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1473432979-16554-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160914170053.0D1DE61AD3@smtp.codeaurora.org> (sfid-20160914_190122_366325_D58C3065)
Date: Wed, 14 Sep 2016 17:00:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> Currently Rx STBC in assoc request frame is advertised as 3. It should
> be 2, as our chipsets support two spatial streams.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

ae1799a1cb13 mwifiex: correction in Rx STBC field of htcapinfo

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9323739/
