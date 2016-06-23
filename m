Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36127 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbcFWBkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 21:40:02 -0400
Received: by mail-io0-f176.google.com with SMTP id s63so55655800ioi.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2016 18:40:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5762DAC7.8090904@riverbed.com>
References: <5762DAC7.8090904@riverbed.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 23 Jun 2016 11:39:41 +1000
Message-ID: <CAGRGNgU6khSR4a99PXo-D5iApq4p6A3Fe+-eWRi1YrhQQ-LF1Q@mail.gmail.com> (sfid-20160623_034008_559091_7D6A901A)
Subject: Re: [PATCH] ath9k: return false when reading wrong eeprom offset
To: Eduardo Abinader <eduardo.abinader@riverbed.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Fri, Jun 17, 2016 at 2:58 AM, Eduardo Abinader
<eduardo.abinader@riverbed.com> wrote:
> Just setting the proper return for reading beyond the eeprom data.
>
> Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>

This makes sense to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
