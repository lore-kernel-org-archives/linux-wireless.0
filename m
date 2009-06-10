Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:59626 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZFJVFB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 17:05:01 -0400
Received: by qw-out-2122.google.com with SMTP id 5so719607qwd.37
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 14:05:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244667817.20900.402.camel@rc-desk>
References: <1244666131-20031-1-git-send-email-lrodriguez@atheros.com>
	<1244666973.20900.399.camel@rc-desk> <43e72e890906101349t502e9022h16fa79ea512f8b4d@mail.gmail.com>
	<1244667817.20900.402.camel@rc-desk>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 10 Jun 2009 14:04:43 -0700
Message-ID: <43e72e890906101404l6a8bee67r560f7c8a1c5f8c36@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] mac80211: disassociate when switching bands
	and not scanning
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>, "j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 2:03 PM, reinette
chatre<reinette.chatre@intel.com> wrote:

>> > This touches code targeted for removal in recent "mac80211: disconnect
>> > when user changes channel" patch.
>>
>> Heh I don't see that patch yet but if it exists that should fix this
>> too unless that patch didn't deauth/disassoc. Did you try with it
>> applied by any chance? I can't seem to find that patch on the list.
>
> That patch does seem to have same intention as yours. It is still RFC so
> I am not sure about its status. I did not test with it, but will do so.
> The patch can be found at
> http://marc.info/?l=linux-wireless&m=124458448631186&w=2

Thanks yes, I see, yup I think that should fix it, we need a fix for
stable though. Not sure how John or Johannes want to handle this.

  Luis
