Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:46265 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbZGGBfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 21:35:51 -0400
Received: by yxe26 with SMTP id 26so6215255yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2009 18:35:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246928780.4652.10.camel@johannes.local>
References: <1246927662-25461-1-git-send-email-javier@cozybit.com>
	 <1246927941-27148-1-git-send-email-javier@cozybit.com>
	 <1246928780.4652.10.camel@johannes.local>
Date: Mon, 6 Jul 2009 18:35:53 -0700
Message-ID: <445f43ac0907061835i2b21e8aj71d6ef93aa8123ea@mail.gmail.com>
Subject: Re: [PATCH] Fix regression in mesh forwarding path.
From: Javier Cardona <javier@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Andrey Yurovsky <andrey@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 6, 2009 at 6:06 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> That does a lot of locking operations -- can you not select the queue
> earlier, and use ieee80211_add_pending_skbs?

Indeed.  Just submitted v2 of the patch.

Thanks!

Javier


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
