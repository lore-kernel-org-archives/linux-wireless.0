Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab1DFLBO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 07:01:14 -0400
Message-ID: <4D9C47D2.9040703@redhat.com>
Date: Wed, 06 Apr 2011 19:00:34 +0800
From: Cong Wang <amwang@redhat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Patch] wireless: remove obsolete ar9170usb driver
References: <1302086160-9158-1-git-send-email-amwang@redhat.com> <1302086729.3811.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1302086729.3811.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

于 2011年04月06日 18:45, Johannes Berg 写道:
> On Wed, 2011-04-06 at 18:36 +0800, Amerigo Wang wrote:
>> AR9170USB is scheduled to be removed in 2.6.40.
>>
>> Cc: Christian Lamparter<chunkeey@googlemail.com>
>
> Christian already submitted this patch, and I believe it was merged.
>
> What tree are you working against? You seem to be missing a bunch of
> wireless things that _should_ be in linux-next (I was going to check but
> git.kernel.org is really slow right now)?
>

It is based on today's Linus tree and I also checked the latest net-next-2.6.
Sorry that I missed the wireless tree.

Anyway, good to see this is already removed.

Thanks.
