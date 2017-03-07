Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44726 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755401AbdCGOjz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 09:39:55 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Takashi Iwai <tiwai@suse.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH v2 1/4] brcmfmac: Do not print the firmware version as an error
References: <20170227214539.16422-1-hdegoede@redhat.com>
Date: Tue, 07 Mar 2017 16:30:08 +0200
In-Reply-To: <20170227214539.16422-1-hdegoede@redhat.com> (Hans de Goede's
        message of "Mon, 27 Feb 2017 22:45:36 +0100")
Message-ID: <87innl88i7.fsf@kamboji.qca.qualcomm.com> (sfid-20170307_154003_620849_BCD19E42)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans de Goede <hdegoede@redhat.com> writes:

> Using pr_err for things which are not errors is a bad idea. E.g. it
> will cause the plymouth bootsplash screen to drop back to the text
> console so that the user can see the error, which is not what we
> normally want to happen.
>
> Instead add a new brcmf_info macro and use that.
>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> -Fix brcm_err typo (should be brcmf_err) in CONFIG_BRCM_TRACING case

Oh, missed that there was v2.

-- 
Kalle Valo
