Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46234 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbZKKGdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 01:33:13 -0500
Received: by ewy3 with SMTP id 3so844924ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 22:33:17 -0800 (PST)
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH v2] rt2x00: Initialize rf302x RF values properly for rt2800pci.
References: <1257889360-388-1-git-send-email-gwingerde@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 11 Nov 2009 08:33:15 +0200
In-Reply-To: <1257889360-388-1-git-send-email-gwingerde@gmail.com> (Gertjan van Wingerde's message of "Tue\, 10 Nov 2009 22\:42\:40 +0100")
Message-ID: <874op1efkk.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde <gwingerde@gmail.com> writes:

> Ensure RF302x and RF2020 chipsets are handled properly in rt2800lib for the rt3090 chipset.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Please line wrap commit logs. 72 characters or so per line is a good
limit.

-- 
Kalle Valo
