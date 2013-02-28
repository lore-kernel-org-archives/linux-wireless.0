Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:59695 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3B1XeK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 18:34:10 -0500
Received: by mail-la0-f41.google.com with SMTP id fo12so2392612lab.0
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2013 15:34:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360797364-9430-2-git-send-email-johannes@sipsolutions.net>
References: <1360797364-9430-1-git-send-email-johannes@sipsolutions.net> <1360797364-9430-2-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 28 Feb 2013 15:33:47 -0800
Message-ID: <CAB=NE6VonnZDQwat3PeCvnVJnuj-vKciK8WYCmbLzre+4zoLyw@mail.gmail.com> (sfid-20130301_003415_342637_C5648F15)
Subject: Re: [PATCH 1/3] regulatory: allow VHT channels in world roaming
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, green@qca.qualcomm.com,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 13, 2013 at 3:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> For VHT, the wider bandwidths (up to 160 MHz) need
> to be allowed. Since world roaming only covers the
> case of connecting to an AP, it can be opened up
> there, we will rely on the AP to know the local
> regulations.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

This seems reasonable to me but in your patch you only allow 80, not
160, any reason for that? Michael, any thoughts, this would just be
for passive scan, STA only, we'd rely on the AP existing and having
such configuration.

  Luis
