Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:54986 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbZHDPN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 11:13:28 -0400
Received: by vws2 with SMTP id 2so1422658vws.4
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 08:13:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A754562.8000107@gmx.de>
References: <4A74C2B6.3070407@gmx.de> <20090802032019.GA25339@hash.localnet>
	 <4A754562.8000107@gmx.de>
Date: Tue, 4 Aug 2009 11:13:28 -0400
Message-ID: <b6c5339f0908040813y7dbe45a8h8b02524efc6e9def@mail.gmail.com>
Subject: Re: [PATCH v2] ath5k: fix missing output in monitor mode after
	ifconfig up
From: Bob Copeland <me@bobcopeland.com>
To: Joerg Albert <jal2@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 2, 2009 at 3:50 AM, Joerg Albert<jal2@gmx.de> wrote:
> Let ath5k_chan_set() always call ath5k_reset().
> This fixes the bug that we don't
> get any packets in monitor mode after:

Thanks!  Looks good.

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
