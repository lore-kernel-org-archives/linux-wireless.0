Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34238 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbcFXEWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2016 00:22:48 -0400
Received: by mail-io0-f169.google.com with SMTP id g13so83113990ioj.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 21:22:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160623145714.20576-5-martin.blumenstingl@googlemail.com>
References: <20160623145714.20576-1-martin.blumenstingl@googlemail.com> <20160623145714.20576-5-martin.blumenstingl@googlemail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 24 Jun 2016 14:22:28 +1000
Message-ID: <CAGRGNgU2bC=SiBmQWC4-N7cDicri1kDfHw=49FfWTnCCc+8nvw@mail.gmail.com> (sfid-20160624_062708_715008_1773FAB4)
Subject: Re: [PATCH 4/6] ath9k: remove return value from ath9k_hw_init_macaddr
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Fri, Jun 24, 2016 at 12:57 AM, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> ath9k_hw_init_macaddr unconditionally returns 0 in all cases, making the
> return value unnecessary.
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
