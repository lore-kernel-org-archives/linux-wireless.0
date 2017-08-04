Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49566 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbdHDGcO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Aug 2017 02:32:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wireless: move prism54 out to staging
References: <20170803235937.8604-1-mcgrof@kernel.org>
        <20170803235937.8604-2-mcgrof@kernel.org>
Date: Fri, 04 Aug 2017 09:32:03 +0300
In-Reply-To: <20170803235937.8604-2-mcgrof@kernel.org> (Luis R. Rodriguez's
        message of "Thu, 3 Aug 2017 16:59:36 -0700")
Message-ID: <87lgmzn8rg.fsf@kamboji.qca.qualcomm.com> (sfid-20170804_083230_207035_4EB7D816)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@kernel.org> writes:

> prism54 is deprecated in favor of the p54pci device driver. Although
> only *one soul* had reported issues with it long ago Linux most Linux
> distributions these days just disable the device driver given the
> conflicts with the PCI IDs of p54pci and the *very* unlikely situation
> of folks really need this driver anymore.
>
> Before trying to due away with prism54 once more stuff it into staging,
> which is our hospice for dying drivers.
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
