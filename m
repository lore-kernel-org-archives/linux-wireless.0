Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f173.google.com ([209.85.222.173]:34031 "EHLO
	mail-pz0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab0BEPxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 10:53:14 -0500
Received: by pzk3 with SMTP id 3so1040075pzk.5
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2010 07:53:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265366706.3613.3.camel@johannes.local>
References: <1265366706.3613.3.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 5 Feb 2010 07:52:54 -0800
Message-ID: <43e72e891002050752w3dcb736ek4c5fd773ef402755@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix bss_conf.dtim_period
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 5, 2010 at 2:45 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> In AP mode, the only mode where the parameter
> is supposed to be valid, we never assign it!
> Fix that to allow drivers to avoid parsing
> the TIM IE for the value.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Stable fix too?

  Luis
