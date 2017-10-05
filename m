Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:44343 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751339AbdJEOjS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 10:39:18 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC v2 1/2] fq: support filtering a given tin
In-Reply-To: <20171005131803.12328-1-johannes@sipsolutions.net>
References: <20171005131803.12328-1-johannes@sipsolutions.net>
Date: Thu, 05 Oct 2017 16:39:12 +0200
Message-ID: <87h8vdslpr.fsf@toke.dk> (sfid-20171005_163921_758471_63595289)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> Add to the FQ API a way to filter a given tin, in order to
> remove frames that fulfil certain criteria according to a
> filter function.
>
> This will be used by mac80211 to remove frames belonging to
> an AP VLAN interface that's being removed.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Yup, this version looks reasonable to me :)

-Toke
