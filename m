Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34222 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbaEHL2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 07:28:49 -0400
Received: by mail-ig0-f175.google.com with SMTP id uq10so6478029igb.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2014 04:28:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399447711-12441-1-git-send-email-helmut.schaa@googlemail.com>
References: <1399447711-12441-1-git-send-email-helmut.schaa@googlemail.com>
Date: Thu, 8 May 2014 13:28:48 +0200
Message-ID: <CAGXE3d8C8+qOc0xETnQv1dD1sUkrxvzt04pFSwnw4AwcnHS2SA@mail.gmail.com> (sfid-20140508_132852_775895_63206DB0)
Subject: Re: [PATCH] ath9k: Allow platform override without EEPROM override
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, Felix Fietkau <nbd@openwrt.org>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 7, 2014 at 9:28 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Add a new platform data flag "use_eeprom" that indicates that the eeprom
> found on the card itself should be used instead of the one present in
> the platform data.
>
> This allows to override the MAC address of a PCI card while preserving
> the eeprom data from the card itself.
>
> The default behavior is preserved.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

John, please hold on this one. I'll send a v2.
Helmut
