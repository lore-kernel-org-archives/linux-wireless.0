Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57937 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753231AbcICRBL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 13:01:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2] rtlwifi: Fix missing country code for Great Britain
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1471894079-14330-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Message-Id: <20160903170038.9051062181@smtp.codeaurora.org> (sfid-20160903_190116_214787_F23352EA)
Date: Sat,  3 Sep 2016 17:00:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Some RTL8821AE devices sold in Great Britain have the country code of
> 0x25 encoded in their EEPROM. This value is not tested in the routine
> that establishes the regulatory info for the chip. The fix is to set
> this code to have the same capabilities as the EU countries. In addition,
> the channels allowed for COUNTRY_CODE_ETSI were more properly suited
> for China and Israel, not the EU. This problem has also been fixed.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

Thanks, 1 patch applied to wireless-drivers-next.git:

0c9d34915307 rtlwifi: Fix missing country code for Great Britain

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9294303/
