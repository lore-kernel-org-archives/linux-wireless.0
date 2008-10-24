Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:40879 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbYJXS7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 14:59:00 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1001275rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2008 11:58:59 -0700 (PDT)
Message-ID: <b6c5339f0810241158t59b15861qc9eb05a3f3f032a2@mail.gmail.com> (sfid-20081024_205906_530246_E1E5D601)
Date: Fri, 24 Oct 2008 14:58:59 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [ath5k-devel] ath5k: badness at net/mac80211/rx.c:2200, status->rate_idx = 255
Cc: ath5k-devel@lists.ath5k.org,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081023213333.4t4427vw5ws8ccck-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224799927.22806.15.camel@dv>
	 <20081023213333.4t4427vw5ws8ccck-cebfxv@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 23, 2008 at 9:33 PM, Pavel Roskin <proski@gnu.org> wrote:
> Oh well, I still get the same badness:
> status->rate_idx = -1, sband->n_bitrates = 12

There have been a rash of warnings in this area lately:

http://article.gmane.org/gmane.linux.drivers.ath5k.devel/1311
http://article.gmane.org/gmane.linux.drivers.ath5k.devel/1353 (end)

also possibly related:

http://article.gmane.org/gmane.linux.kernel.wireless.general/22711

I guess like ath9k, rc stuff isn't setup properly, but I wouldn't know.

-- 
Bob Copeland %% www.bobcopeland.com
