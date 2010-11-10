Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55933 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab0KJRNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 12:13:18 -0500
Received: by iwn10 with SMTP id 10so1031157iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 09:13:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289391686-27632-3-git-send-email-rmanoharan@atheros.com>
References: <1289391686-27632-1-git-send-email-rmanoharan@atheros.com> <1289391686-27632-3-git-send-email-rmanoharan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 10 Nov 2010 09:12:57 -0800
Message-ID: <AANLkTinOpJpkNjfseqx3kVHxvogqJFGtmkc0DzWZEf95@mail.gmail.com>
Subject: Re: [PATCH 3/3] ath9k_hw: Set proper eeprom offset for AR9287 HTC devices
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 4:21 AM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> AR9287 based PCI & USB devices are differed in eeprom start offset.
> So set proper the offset for HTC devices to read nvram correctly.

What would happen otherwise?
