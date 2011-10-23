Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46801 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1JWVA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 17:00:57 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt19so7346339bkb.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Oct 2011 14:00:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111023193604.GA18257@jm.kir.nu>
References: <20111023193604.GA18257@jm.kir.nu>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 23 Oct 2011 23:00:42 +0200
Message-ID: <CA+XVXfdUwfr6oA5x1gg2O8mCq9vBghmiFUqbeeAV=wxse5V6XQ@mail.gmail.com> (sfid-20111023_230107_238752_17757232)
Subject: Re: [PATCH] mac80211: Fix TDLS support validation in add_station handler
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 23, 2011 at 21:36, Jouni Malinen <j@w1.fi> wrote:
> We need to verify whether the command is successful before allocating
> the station entry to avoid extra processing. This also fixes a memory
> leak on the error path.

Thanks. I missed that one.

Arik
