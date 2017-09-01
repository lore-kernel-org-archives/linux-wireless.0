Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49466 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdIAFad (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 01:30:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Eric Bentley <Eric.Bentley@lairdtech.com>
Cc: Steve deRosier <derosier@gmail.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel\@broadcom.com" <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v2] Correctly fail to suspend when SDIO does not support power on suspend
References: <F895C8CD-1D0E-46CB-9C12-5B4775E76217@lairdtech.com>
Date: Fri, 01 Sep 2017 08:30:28 +0300
In-Reply-To: <F895C8CD-1D0E-46CB-9C12-5B4775E76217@lairdtech.com> (Eric
        Bentley's message of "Fri, 1 Sep 2017 00:04:51 +0000")
Message-ID: <873787nfyj.fsf@purkki.adurom.net> (sfid-20170901_073048_531224_4DEC51BD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eric Bentley <Eric.Bentley@lairdtech.com> writes:

> Return error when failing to set power management capabilities flag.  This will cause the suspend to fail but the radio
> will continue to operate.  Allowing this to fail without reporting error will cause the radio to be non-functional on 
> resume as it will have lost power.
>
> Signed-off-by: Eric Bentley eric.bentley@lairdtech.com

Word wrap the commit log to 72 chars (or so) per line. Also add a prefix
to the title:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
Kalle Valo
