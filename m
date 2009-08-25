Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:37583 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbZHYU6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 16:58:37 -0400
Received: by vws33 with SMTP id 33so88472vws.33
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 13:58:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251232252.9398.2.camel@mj>
References: <20090714015739.GA28490@hash.localnet> <1251232252.9398.2.camel@mj>
Date: Tue, 25 Aug 2009 16:58:39 -0400
Message-ID: <b6c5339f0908251358r7693deefid2a0f738eb508e1f@mail.gmail.com>
Subject: Re: [PATCH 2.6.31] ath5k: temporarily disable crypto for AP mode
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 25, 2009 at 4:30 PM, Pavel Roskin<proski@gnu.org> wrote:
>>
>> Pavel, this ok with you for now?
>
> Sorry for delay.  I don't have time to test it, but I have no specific
> objections.

Thanks, for the update.  It already went to Linus I believe.

I did spend enough time looking at the root problem to decide that
fixing it won't be too hard, but I also saw some questionable logic
in the original code that wants a cleanup, I can post patches soon.

-- 
Bob Copeland %% www.bobcopeland.com
