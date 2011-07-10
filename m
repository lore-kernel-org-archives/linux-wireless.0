Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56626 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab1GJTzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2011 15:55:36 -0400
Received: by pvg12 with SMTP id 12so2264002pvg.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jul 2011 12:55:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107101705.15918.IvDoorn@gmail.com>
References: <201107101705.15918.IvDoorn@gmail.com>
Date: Sun, 10 Jul 2011 21:55:35 +0200
Message-ID: <CACna6rxkhRr2yYNYvbTVs0nE0NN3p_JJ8X9XB0MZzPK6sSCr2g@mail.gmail.com> (sfid-20110710_215540_299673_C2F29A07)
Subject: Re: [PATCH 1/1] Add new device ID for Belkin
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>,
	Eduardo Bacchi Kienetz <eduardo@kienetz.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/10 Ivo van Doorn <ivdoorn@gmail.com>:
> From: Eduardo Bacchi Kienetz <eduardo@kienetz.com>
>
> Belkin's Connect N150 Wireless USB Adapter, model F7D1101 version 2, uses ID 0x945b.
> Chipset info: rt: 3390, rf: 000b, rev: 3213.
> I have just bought one, which started to work perfectly after the ID was added through this patch.

Not a huge hurt, but prefix "rt2x00" would be nice :) Note for a future.

-- 
Rafał
