Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37482 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751750AbdFAJwC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 05:52:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rsi: use subdirectory for firmware file
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1495810891-2914-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1495810891-2914-1-git-send-email-amit.karwar@redpinesignals.com>
To: amit karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Message-Id: <20170601095201.489066073B@smtp.codeaurora.org> (sfid-20170601_115219_152758_D55ED840)
Date: Thu,  1 Jun 2017 09:52:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

amit karwar <amitkarwar@gmail.com> wrote:

> linux-firmware maintainers prefer to have a subdirectory for
> firmware files. Code is changed here to pick firmware file from
> a subdirectory. Firmware file with a new loading mechanism will
> be submitted inside rsi directory.
> 
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Patch applied to wireless-drivers-next.git, thanks.

219569ad0c41 rsi: use subdirectory for firmware file

-- 
https://patchwork.kernel.org/patch/9750657/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
