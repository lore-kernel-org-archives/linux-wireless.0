Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:33649 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755169AbdCGKFB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 05:05:01 -0500
Received: by mail-wr0-f173.google.com with SMTP id u48so135290934wrc.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Mar 2017 02:04:45 -0800 (PST)
Subject: Re: [PATCH v2 3/4] brcmfmac: Do not complain about country code "00"
To: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170227214539.16422-1-hdegoede@redhat.com>
 <20170227214539.16422-3-hdegoede@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <48436967-232a-d7b9-8fbe-9707a4a5fd50@broadcom.com> (sfid-20170307_110625_732973_F11D68FF)
Date: Tue, 7 Mar 2017 11:04:37 +0100
MIME-Version: 1.0
In-Reply-To: <20170227214539.16422-3-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 27-2-2017 22:45, Hans de Goede wrote:
> The country code gets set to "00" by default at boot, ignore this
> rather then logging an error about it.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
>  1 file changed, 4 insertions(+)
