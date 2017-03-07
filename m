Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49028 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932704AbdCGOqB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 09:46:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 0/4] brcmfmac: Remove a bunch of false positive error logs
References: <20170227100140.5190-1-hdegoede@redhat.com>
Date: Tue, 07 Mar 2017 16:27:43 +0200
In-Reply-To: <20170227100140.5190-1-hdegoede@redhat.com> (Hans de Goede's
        message of "Mon, 27 Feb 2017 11:01:36 +0100")
Message-ID: <87mvcx88m8.fsf@kamboji.qca.qualcomm.com> (sfid-20170307_154738_125010_5EFBF114)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans de Goede <hdegoede@redhat.com> writes:

> Here is a small series to stop brcmfmac from spamming dmesg with errors
> which are not really errors at all.
>
> Note the 4th patch actually contains a small behavior change rather then
> just changing logging, so it needs a bit of extra review attention.

Arend, did you miss these? I don't see an ack from you.

-- 
Kalle Valo
