Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60890 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753457AbdEZLIe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 07:08:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH resend 0/1] brcmfmac: p2p and normal ap access are not always possible at the same time
References: <20170526105747.16874-1-hdegoede@redhat.com>
Date: Fri, 26 May 2017 14:08:12 +0300
In-Reply-To: <20170526105747.16874-1-hdegoede@redhat.com> (Hans de Goede's
        message of "Fri, 26 May 2017 12:57:46 +0200")
Message-ID: <87h907ri3n.fsf@kamboji.qca.qualcomm.com> (sfid-20170526_130841_698243_40FADD08)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans de Goede <hdegoede@redhat.com> writes:

> This is a resend of a patch which I send a while ago, back then there
> was some discussion to come up with a better fix, but that has not lead
> to anything and the driver is still periodically spamming the logs.
>
> As such I would like to move forward with this patch for now, which
> makes no functional changes other then changing the messages in question
> into debug messages when the error is -EBUSY.

Link to the old discussion:

https://patchwork.kernel.org/patch/9594385/

-- 
Kalle Valo
