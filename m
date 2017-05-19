Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47318 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbdESGD1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 02:03:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: add missing USB-descriptor endianness conversion
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170512101555.2111-1-johan@kernel.org>
References: <20170512101555.2111-1-johan@kernel.org>
To: Johan Hovold <johan@kernel.org>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Johan Hovold <johan@kernel.org>
Message-Id: <20170519060326.C4CC46085D@smtp.codeaurora.org> (sfid-20170519_080340_170649_4DAA6A0C)
Date: Fri, 19 May 2017 06:03:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johan Hovold <johan@kernel.org> wrote:
> Add the missing endianness conversions to a debug statement printing
> the USB device-descriptor bcdUSB field during probe.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

a1ad7198202f mwifiex: add missing USB-descriptor endianness conversion

-- 
https://patchwork.kernel.org/patch/9723847/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
