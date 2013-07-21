Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35294 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab3GUOTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jul 2013 10:19:12 -0400
Received: by mail-pa0-f44.google.com with SMTP id lj1so6143606pab.17
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jul 2013 07:19:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20971.60401.394690.279877@gargle.gargle.HOWL>
References: <1374413809-26005-1-git-send-email-arik@wizery.com>
 <1374413809-26005-2-git-send-email-arik@wizery.com> <20971.60401.394690.279877@gargle.gargle.HOWL>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 21 Jul 2013 17:18:56 +0300
Message-ID: <CA+XVXfeFE4S-A0iPB3+2utfbKAPE6CTGFiCAhWABo_u+ZZ_4Lg@mail.gmail.com> (sfid-20130721_161927_085984_7859E3DB)
Subject: Re: [PATCH 2/2] regulatory: take RTNL when restoring settings on CRDA timeout
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 21, 2013 at 5:10 PM, Sujith Manoharan <sujith@msujith.org> wrote:
> Arik Nemtsov wrote:
>> The RTNL has to be held since this potentially changes the regdomain.
>> Locking was forgotten here due to recent locking simplification changes.
>
> This is already present in the mac80211 tree:
> https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211.git/commit/?id=f77b86d7d3acf9dfcb5ee834628d12207584b2cb
>

Ah thanks. I missed that. Disregard then please.

Arik
