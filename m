Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49342 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbdHDGbl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Aug 2017 02:31:41 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] wireless: move prism54 to staging
References: <20170803235937.8604-1-mcgrof@kernel.org>
Date: Fri, 04 Aug 2017 09:31:34 +0300
In-Reply-To: <20170803235937.8604-1-mcgrof@kernel.org> (Luis R. Rodriguez's
        message of "Thu, 3 Aug 2017 16:59:35 -0700")
Message-ID: <87pocbn8s9.fsf@kamboji.qca.qualcomm.com> (sfid-20170804_083155_829445_F0554E6C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@kernel.org> writes:

> This moves the prism54 diver to staging. The reason for this are
> stated on the driver's own commit log. Let me know what tree you'd
> prefer this to go through.

Nice. For me it's better if Greg can take this, I suspect less conflicts
that way, but I can take this as well if needed.

-- 
Kalle Valo
