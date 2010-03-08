Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62422 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab0CHT0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 14:26:17 -0500
Received: by vws9 with SMTP id 9so2927956vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 11:26:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267957241-5578-2-git-send-email-hauke@hauke-m.de>
References: <1267957241-5578-1-git-send-email-hauke@hauke-m.de>
	<1267957241-5578-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 8 Mar 2010 11:25:56 -0800
Message-ID: <43e72e891003081125ge6f41c8s4979bc8f71779cb0@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat: backport device_{lock,trylock,unlock}
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Gus Wirth <gwirth79@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 7, 2010 at 2:20 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This fixes build of ar9170.
>
> CC: Gus Wirth <gwirth79@gmail.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks applied both patches!

  Luis
