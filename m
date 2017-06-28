Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51548 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbdF1Sck (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 14:32:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [v2 07/20] rsi: correct the logic of deriving queue number
References: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
        <1497624881-2315-8-git-send-email-amit.karwar@redpinesignals.com>
Date: Wed, 28 Jun 2017 21:32:36 +0300
In-Reply-To: <1497624881-2315-8-git-send-email-amit.karwar@redpinesignals.com>
        (Amitkumar Karwar's message of "Fri, 16 Jun 2017 20:24:28 +0530")
Message-ID: <87tw302caj.fsf@purkki.adurom.net> (sfid-20170628_203244_752511_14E9B26B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> Maximum valid queue number is 0x5. So anding with 0x7 should be
> ok here.
>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

The separate From header is missing which you had in v1.

-- 
Kalle Valo
