Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44806 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1BOVSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 16:18:55 -0500
Received: by qyj19 with SMTP id 19so2740369qyj.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 13:18:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D5AEA3C.4090502@gmail.com>
References: <20110215220929.1cc6e9d4.nledovskikh@gmail.com>
	<4D5AD6A6.8090505@gmail.com>
	<AANLkTiks9rG2CzM2LabNerK3zgJ+R+weytQgvXxDbNe7@mail.gmail.com>
	<4D5AE52B.80002@gmail.com>
	<AANLkTikyneyczm=+XRfjUEVJU-i4d6d=7yF4Lh=8Do_=@mail.gmail.com>
	<4D5AEA3C.4090502@gmail.com>
Date: Wed, 16 Feb 2011 00:18:54 +0300
Message-ID: <AANLkTikRfZUaVct1sxTOegs70rEq6k7LsNwj49ii=FGH@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Use mips generic dma-mapping functions to avoid
 seqfault on AHB chips
From: Nikolay Ledovskikh <nledovskikh@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, me@bobcopeland.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, I take it into account.
So we need to investigate the platform code?
