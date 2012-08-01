Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34770 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab2HAVEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 17:04:40 -0400
Received: by ggnl2 with SMTP id l2so553301ggn.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2012 14:04:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343842772.4638.15.camel@jlt3.sipsolutions.net>
References: <CAMLZHHQkv_fHzd89fP7bNow7eL3oX+Duzr5rS5NJfhffqwUv2g@mail.gmail.com>
	<1343842772.4638.15.camel@jlt3.sipsolutions.net>
Date: Wed, 1 Aug 2012 15:04:39 -0600
Message-ID: <CAMLZHHQofS=s0E=zMsuRJLzXPWtkMHOJiN2rZy=41qRYmkw44A@mail.gmail.com> (sfid-20120801_230443_521893_E0F64A0D)
Subject: Re: cfg80211_disconnected memory leak
From: Daniel Drake <dsd@laptop.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 1, 2012 at 11:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> This is very odd. What version of the kernel is this?

3.3, and just reproduced on 3.5.

I'll have a closer look later in the week.

Thanks
Daniel
