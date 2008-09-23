Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:65044 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbYIWCTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 22:19:37 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1564420fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 19:19:35 -0700 (PDT)
Message-ID: <1ba2fa240809221919i251a6f3ft3381ae46302912fb@mail.gmail.com> (sfid-20080923_041942_505155_8526AB99)
Date: Tue, 23 Sep 2008 05:19:35 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] iwlwifi 2.6.27: send all the calibration results instead of the last one only
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	emmanuel.grumbach@intel.com
In-Reply-To: <20080922.184125.147225416.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222128868-16763-1-git-send-email-tomas.winkler@intel.com>
	 <20080922.184125.147225416.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 23, 2008 at 4:41 AM, David Miller <davem@davemloft.net> wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
> Date: Tue, 23 Sep 2008 03:14:28 +0300
>
>> Note this patch effects only 5000 HW (nor 3946 or 4965) so doesn't
>> resolve or create any regression. Anyhow it was thoroughly tested.
>
> You haven't learned the first time.
>
> This kind of stuff is not appropriate outside of the merge window, I'm
> not pulling this change into my tree if John tries to send it to me.

I really really really really don't understand what is wrong with this.
This is new hardware portion of the driver in 2.6.27 which can be even
compiled out with IWL5000.  This was not part of 2.6.26. Sorry for
asking again how this is differing from ath9k patches just accepted.
Please answer this even if you have to be rude your way.

This is serious bug as radio is not configured properly affect greatly
radio performance up to disconnection.
We've limited the number of lines to minimum just to address THE
specific problem and tested it properly.
This bug was introduced in the merging window and discovered after it
was closed there is nothing I can do about that unfortunate timing.

Even if you don't accept this patch here it is, it fixes the problem
in 2.6.27 this is the bottom line, maybe someone find it useful.

Best regards
Tomas
