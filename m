Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36970 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab0KLT6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:58:25 -0500
Received: by vws13 with SMTP id 13so1115748vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 11:58:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CDD971D.5080204@openwrt.org>
References: <5575430.811289486702581.JavaMail.wlan@CHBU500181>
	<12495562.1171289487502962.JavaMail.wlan@CHBU500181>
	<AANLkTinE7LE7OXOq+DrUQfwOAjckaV5A3JbGUSD3vp9h@mail.gmail.com>
	<4CDD971D.5080204@openwrt.org>
Date: Fri, 12 Nov 2010 14:58:24 -0500
Message-ID: <AANLkTi=JgDALN7JmZd2-PfJ+aemj+ug+dgZy+PGd1wiy@mail.gmail.com>
Subject: Re: [PATCH 9/9] ath5k: AHB port. Fix reset and interrupts for AHB
 type of devices.
From: Bob Copeland <me@bobcopeland.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Wojciech Dubowik <dubowoj@neratec.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 12, 2010 at 2:35 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Do you need this hunk?  We never enable the sleep clock for AP mode.
>>
> What does this have to do with AP mode? Some people use these devices in
> station mode.
> If I remember correctly, these devices have problems with sleep clock,
> maybe because parts of the WMAC clock overlap with the CPU clock
> (they're inside the same chip after all).

Well I mentioned it because I didn't know how old the patchset was
originally, and we had problems with the TSF and sleep clock in general
in AP mode, so I didn't know if this line was working around the same
issue.

-- 
Bob Copeland %% www.bobcopeland.com
