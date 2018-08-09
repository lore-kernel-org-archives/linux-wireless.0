Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39832 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732422AbeHIRdO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 13:33:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] mt76x0: correct type for eeprom gain value
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1533631389-417-1-git-send-email-sgruszka@redhat.com>
References: <1533631389-417-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-Id: <20180809150755.1570B60B74@smtp.codeaurora.org> (sfid-20180809_170757_732091_214869A1)
Date: Thu,  9 Aug 2018 15:07:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Change type to u8 to allow sanity check agaist 0xff;
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: e87b5039511a ("mt76x0: eeprom files")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

5dc5bf2899a5 mt76x0: correct type for eeprom gain value

-- 
https://patchwork.kernel.org/patch/10558375/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
