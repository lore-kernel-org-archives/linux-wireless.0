Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62462 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681Ab3DBMDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 08:03:45 -0400
Received: by mail-wg0-f42.google.com with SMTP id k13so3037725wgh.3
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2013 05:03:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5159C697.4040609@openwrt.org>
References: <CAMgrJ3b0EUUae8k1Z2RR92eLbFyPGpqA5px1J_gALDTJ+rmAnA@mail.gmail.com>
 <5159C697.4040609@openwrt.org>
From: Robert Shade <robert.shade@gmail.com>
Date: Tue, 2 Apr 2013 08:03:24 -0400
Message-ID: <CAMgrJ3YFCY1gFp6sT5HJw-KVpvGpx82_HiZkWBDQj1Me96Bw=w@mail.gmail.com> (sfid-20130402_140349_985811_1BE6A863)
Subject: Re: [PATCH] ath9k: Re-enable interrupts after a channel change failure
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 1, 2013 at 1:40 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Your patch is badly whitespace damaged.

Ouch, must be the gmail web client.  I'll resubmit a fixed one.

> Why the call to ath9k_hw_set_interrupts here?

Simply because that's what ath_complete_reset does
