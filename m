Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47322 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935319AbdEXNsj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 09:48:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rt2x00: Add device ID for Epson WN7512BEP
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1495099670-2813-1-git-send-email-tomg@records.headdesk.com.au>
References: <1495099670-2813-1-git-send-email-tomg@records.headdesk.com.au>
To: Tom Gaudasinski <tomg@records.headdesk.com.au>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        helmut.schaa@googlemail.com,
        Tom Gaudasinski <tomg@records.headdesk.com.au>
Message-Id: <20170524134839.2D35E61155@smtp.codeaurora.org> (sfid-20170524_154930_333897_DA74CC23)
Date: Wed, 24 May 2017 13:48:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tom Gaudasinski <tomg@records.headdesk.com.au> wrote:
> Make Epson WN7512BEP work by adding its device-id to rt2800usb. Device
> contains a Ralink RT3071L, registers as vendor Accton/Arcadyan.
> 
> Signed-off-by: Tom Gaudasinski <tomg@records.headdesk.com.au>

Patch applied to wireless-drivers-next.git, thanks.

1a79ddaa903b rt2x00: Add device ID for Epson WN7512BEP

-- 
https://patchwork.kernel.org/patch/9732985/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
