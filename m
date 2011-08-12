Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41252 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1HLObb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 10:31:31 -0400
Received: by yie30 with SMTP id 30so1983388yie.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 07:31:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313156101-16817-8-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
	<1313156101-16817-8-git-send-email-arend@broadcom.com>
Date: Fri, 12 Aug 2011 16:31:29 +0200
Message-ID: <CACna6rwAm9_XhmeD_hp4Q6qak9oJJNJDZ6a9ry2aTw3Dwg4riQ@mail.gmail.com> (sfid-20110812_163134_133826_11C76D0D)
Subject: Re: [PATCH 07/14] staging: brcm80211: absorb brcmf_sdioh_interrupt_register
 into brcmf_sdcard_intr_reg
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org, Franky Lin <frankyl@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/12 Arend van Spriel <arend@broadcom.com>:
> +       BRCMF_TRACE(("brcmf: ***IRQHandler\n"));

> +       BRCMF_TRACE(("%s: Entering\n", __func__));

I guess I'd be way easier to modify your macro instead of having to
remember about double braces every time (assuming there are needed at
all).

-- 
Rafał
