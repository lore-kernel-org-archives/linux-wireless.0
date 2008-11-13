Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:25127 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYKMCYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 21:24:36 -0500
Received: by yx-out-2324.google.com with SMTP id 8so334029yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 18:24:35 -0800 (PST)
Message-ID: <43e72e890811121824h70cdaci9eefe4fd625aafc9@mail.gmail.com> (sfid-20081113_032442_152378_DC800A48)
Date: Wed, 12 Nov 2008 18:24:35 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [otus-devel] [FYI] ar9170 driver
Cc: "otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1226540559.14186.56.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226531034.14186.39.camel@johannes.berg>
	 <1226531788.14186.41.camel@johannes.berg>
	 <1226537117.14186.44.camel@johannes.berg>
	 <1226540559.14186.56.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 12, 2008 at 5:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-11-13 at 01:45 +0100, Johannes Berg wrote:
>
>> Better URL is
>> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-ar9170.patch
>
> In addition to that, you will want to apply this patch
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211-fix-tasklet.patch
> too because otherwise sometimes mac80211 will schedule a disabled
> tasklet with the expected dead loop consequence, and then later will
> even wait for it to finish... I'll submit this proper once I've figured
> out why it's happening.

I get a 404 on the second patch.

  Luis
