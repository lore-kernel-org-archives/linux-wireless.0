Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:49243 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3HTM7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 08:59:14 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so368810wes.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Aug 2013 05:59:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1376681980-27831-1-git-send-email-mkl@pengutronix.de>
References: <1376681980-27831-1-git-send-email-mkl@pengutronix.de>
Date: Tue, 20 Aug 2013 14:59:13 +0200
Message-ID: <CAGXE3d94GvvGev2Y0o36LzRj2ztSgVFsx0LqYD2sD7Shq1-e3A@mail.gmail.com> (sfid-20130820_145917_166192_EF095A51)
Subject: Re: [PATCH v2] ath9k_htc: Restore skb headroom when returning skb to mac80211
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@lists.ath9k.org, Marc Kleine-Budde <mkl@blackshift.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 16, 2013 at 9:39 PM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> Tested in ARMv5 with USB device
>   "ID 0cf3:7015 Atheros Communications, Inc. TP-Link TL-WN821N v3 802.11n [Atheros AR7010+AR9287]"
> for four weeks. Without that patch the kernel oopes after about one week.

Thanks for testing by the way!
Helmut
