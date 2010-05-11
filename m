Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55428 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab0EKSQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 14:16:08 -0400
Received: by pva18 with SMTP id 18so147855pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 11:16:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273591383-76696-2-git-send-email-nbd@openwrt.org>
References: <1273591383-76696-1-git-send-email-nbd@openwrt.org>
	<1273591383-76696-2-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 11 May 2010 11:15:46 -0700
Message-ID: <AANLkTilDwhBErduNt_vZLSsEVVkC1SDMwUPkoumym1o3@mail.gmail.com>
Subject: Re: [PATCH 2/4] ath9k: add debugfs files for reading/writing the rx
	and tx chainmask
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 8:23 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

How about we use bruno's patch instead and we help review it for
802.11n? Then this would not be needed?

  Luis
