Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:61267 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2KLPVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 10:21:34 -0500
Received: by mail-la0-f46.google.com with SMTP id h6so4652740lag.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 07:21:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352713941-12487-1-git-send-email-johannes@sipsolutions.net>
References: <1352713941-12487-1-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 12 Nov 2012 16:21:13 +0100
Message-ID: <CAB=NE6WTycoHBeaqryT4B7y968i1ueBcCqBhWYkwb3nb947Jgg@mail.gmail.com> (sfid-20121112_162139_258839_CDEFE9BF)
Subject: Re: [PATCH 3.7] wireless: allow 40 MHz on world roaming channels 12/13
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2012 at 10:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When in world roaming mode, allow 40 MHz to be used
> on channels 12 and 13 so that an AP that is, e.g.,
> using HT40+ on channel 9 (in the UK) can be used.
>
> Cc: stable@vger.kernel.org
> Reported-by: Eddie Chapman <eddie@ehuk.net>
> Tested-by: Eddie Chapman <eddie@ehuk.net>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

  Luis
