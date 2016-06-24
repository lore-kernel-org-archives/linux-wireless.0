Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35732 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbcFXEUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2016 00:20:51 -0400
Received: by mail-io0-f173.google.com with SMTP id f30so90076091ioj.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 21:20:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160623145714.20576-3-martin.blumenstingl@googlemail.com>
References: <20160623145714.20576-1-martin.blumenstingl@googlemail.com> <20160623145714.20576-3-martin.blumenstingl@googlemail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 24 Jun 2016 14:20:31 +1000
Message-ID: <CAGRGNgU-C3C++3U8dEESSNaqwouP_z4C5gOj9rfE9FuyvULdXw@mail.gmail.com> (sfid-20160624_062146_416289_17CAF613)
Subject: Re: [PATCH 2/6] ath9k: remove variable which is set but never read
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
> No functional changes - this only removes a variable which is set but
> never read.
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
