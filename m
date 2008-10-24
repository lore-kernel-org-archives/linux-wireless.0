Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:47225 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbYJXTBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 15:01:08 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1002051rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2008 12:01:07 -0700 (PDT)
Message-ID: <b6c5339f0810241201r7f8ba34ej6f39a96e371849eb@mail.gmail.com> (sfid-20081024_210114_371100_A16C6B71)
Date: Fri, 24 Oct 2008 15:01:07 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [ath5k-devel] ath5k: badness at net/mac80211/rx.c:2200, status->rate_idx = 255
Cc: ath5k-devel@lists.ath5k.org,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b6c5339f0810241158t59b15861qc9eb05a3f3f032a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224799927.22806.15.camel@dv>
	 <20081023213333.4t4427vw5ws8ccck-cebfxv@webmail.spamcop.net>
	 <b6c5339f0810241158t59b15861qc9eb05a3f3f032a2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2008 at 2:58 PM, Bob Copeland <me@bobcopeland.com> wrote:
> http://article.gmane.org/gmane.linux.kernel.wireless.general/22711
>
> I guess like ath9k, rc stuff isn't setup properly, but I wouldn't know.

Err, that's tx path not rx, so maybe not.

-- 
Bob Copeland %% www.bobcopeland.com
