Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36655 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbcFDTo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 15:44:56 -0400
Received: by mail-oi0-f48.google.com with SMTP id j1so173969844oih.3
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jun 2016 12:44:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57526D1D.9000305@gmx.net>
References: <CAArymCnfQaa29D2EXGzwOrp0yvXES+Qq1X-HbSUxC6gig8pH_A@mail.gmail.com>
 <57526D1D.9000305@gmx.net>
From: bruce m beach <brucembeach@gmail.com>
Date: Sat, 4 Jun 2016 12:44:55 -0700
Message-ID: <CAArymCm7SgKyK_cy+MucMb5-8nDZshiOCu-mPVyKR6WnNCm5Lg@mail.gmail.com> (sfid-20160604_214459_491210_39DD7B9E)
Subject: ath9k_htc firmware
To: Oleksij Rempel <fishor@gmx.net>
Cc: ath9k-devel@lists.ath9k.org, ath9k_htc_fw@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> I'm looking for some kind of simple request in the ath9k_htc driver, through
>> the usb ep0, like a memory read on the card, where a urb is sent with
>> the resulting chain of events. The simpler the better. The simplest.

> For EP0 on drivers site:
> static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
> {
> int transfer, err;
> const void *data = hif_dev->fw_data;
> size_t len = hif_dev->fw_size;
> u32 addr = AR9271_FIRMWARE;
> u8 *buf = kzalloc(4096, GFP_KERNEL);
> u32 firm_offset;
> ...

  What about the code for setting and resetting leds ???

Bruce
