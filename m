Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54384 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1C1K3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 06:29:14 -0400
Received: by qwk3 with SMTP id 3so1794002qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 03:29:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301250786-9157-1-git-send-email-xose.vazquez@gmail.com>
References: <1301250786-9157-1-git-send-email-xose.vazquez@gmail.com>
Date: Mon, 28 Mar 2011 12:29:13 +0200
Message-ID: <AANLkTi=g26YLujtzfB=4Wfm4nDtnKJcfDR_ZeC4f6NKn@mail.gmail.com>
Subject: Re: [PATCH] wireless: rt2x00: rt2800usb.c add and identify ids
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, gwingerde@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> taken from staging/rt2860
> 0x0411,0x016f de37cd49b5a54facef174cf34496919857436e8f MelCo(Buffalo) WLI-UC-G301N
> 0x050d,0x825b 12840c63b0679f7fab88ea1cc26b52db8b574ce7 Belkin F5D8055
> 0x050d,0x935a 705059a670f3af2b37695e82de0ee58e75e656ed Belkin F6D4050 v1
> 0x050d,0x935b 5d92fe3387d086fc2f10426fbdb6b86d6cce5a47 Belkin F6D4050 v2
>
> identifed from ralink driverss
> 0x0930,0x0a07 RT35xx TOSHIBA 2010_1215_RT3572_Linux_STA_v2.5.0.0.DPO
> 0x1d4d,0x0011 3072 Pegatron 2011_0107_RT3070_RT3370_Linux_STA_v2.5.0.1_DPO
>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
