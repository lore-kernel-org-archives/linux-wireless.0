Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:60981 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbcHVLnK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 07:43:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, chunkeey@googlemail.com, nbd@nbd.name
Subject: Re: [PATCH 1/5] ath9k: Add a #define for the EEPROM "eepmisc" endianness bit
Date: Mon, 22 Aug 2016 13:42:45 +0200
Message-ID: <2740315.pSGMQEQKgf@wuerfel> (sfid-20160822_134314_465198_539AF9D3)
In-Reply-To: <20160821144906.30984-2-martin.blumenstingl@googlemail.com>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com> <20160821144906.30984-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, August 21, 2016 4:49:02 PM CEST Martin Blumenstingl wrote:
> This replaces a magic number with a named #define. Additionally it
> removes two "eeprom format" specific #defines for the "big endianness"
> bit which are the same on all eeprom formats.
> 

Looks good, but missing a Signed-off-by: tag.

	Arnd
