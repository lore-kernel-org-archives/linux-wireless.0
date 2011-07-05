Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63323 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1GEUi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:38:28 -0400
Received: by pvg12 with SMTP id 12so5465725pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 13:38:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309896377-4425-1-git-send-email-arend@broadcom.com>
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
Date: Tue, 5 Jul 2011 22:38:27 +0200
Message-ID: <CACna6rwqWnrK_UOhx8OEwm9vPv+LYtv6kV8frnQHB6c4wB3ZJQ@mail.gmail.com> (sfid-20110705_223832_617971_AE205FB0)
Subject: Re: [PATCH v2 00/21] staging: brcm80211: mostly fullmac cleanup patches
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/5 Arend van Spriel <arend@broadcom.com>:
> (...)
>  staging: brcm80211: removed brcmf_sdioh_interrupt_pending()
>  staging: brcm80211: removed brcmf_sdioh_reset()
>  staging: brcm80211: removed brcmf_sdioh_start() and
>    brcmf_sdioh_stop()

Arend, can you say something more about what does happen here?

You drop some functions that were empty, but I guess there were here
for some reason. Did you discover in development process that things
like start/stop/reset is not needed? Or did you put place for
something that appeared to be not available on SDIO?

Shouldn't we keep it here and just implement lacking code?

-- 
Rafał
