Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54805 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab1ALVLB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 16:11:01 -0500
Received: by iwn9 with SMTP id 9so939504iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 13:11:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294796791-2521-1-git-send-email-lrodriguez@atheros.com>
References: <1294796791-2521-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 12 Jan 2011 13:10:40 -0800
Message-ID: <AANLkTimAA5AfvPxVZLmCngetNm_EoVNgjxSitXMtORyF@mail.gmail.com>
Subject: Re: [PATCH] ath9k_hw: disable PLL / Clkreq for ASPM for AR9003
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Jack Lee <jack.lee@atheros.com>,
	Carl Huang <carl.huang@atheros.com>,
	David Quan <david.quan@atheros.com>,
	Nael Atallah <nael.atallah@atheros.com>,
	Sarvesh Shrivastava <sarvesh.shrivastava@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please hold on

On Tue, Jan 11, 2011 at 5:46 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This changes the PCIE PHY programming for better interoperability
> with ASPM states. Without this AR9003 chipsets will hang when
> using ASPM. This reproducible against an Apple Airport Extreme AP
> by simply pinging it.
>
> Cc: stable@kernel.org
> Cc: Jack Lee <jack.lee@atheros.com>
> Cc: Carl Huang <carl.huang@atheros.com>
> Cc: David Quan <david.quan@atheros.com>
> Cc: Nael Atallah <nael.atallah@atheros.com>
> Cc: Sarvesh Shrivastava <sarvesh.shrivastava@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

John, if you have not merged this, please hold on this, I forgot one bit.

  Luis
