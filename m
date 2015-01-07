Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59098 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbbAGKEU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 05:04:20 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so7118945wid.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 02:04:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1419834066-11802-1-git-send-email-sujith@msujith.org>
References: <1419834066-11802-1-git-send-email-sujith@msujith.org>
Date: Wed, 7 Jan 2015 11:04:19 +0100
Message-ID: <CA+BoTQ=Vt8BTzZcgxqq4eU+RKhMwNbGrZOOFGL9TcBA3KnrerQ@mail.gmail.com> (sfid-20150107_110425_929577_D9BDDF24)
Subject: Re: [PATCH] ath10k: Fix DMA burst size
From: Michal Kazior <michal.kazior@tieto.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 December 2014 at 07:21, Sujith Manoharan <sujith@msujith.org> wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> A value of zero indicates that 128B is the maximum
> DMA request size for read/writes. But PCI cards based
> on AR9880 can support 256B, so enable this for
> the 10.2 firmware.

Since it's for cards/chips why do you enable it for 10.2 only? There's
10.1, main and tlv as well which could possibly benefit from this.


Michał
