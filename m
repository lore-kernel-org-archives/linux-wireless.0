Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.228]:63621 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYJXSdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 14:33:31 -0400
Received: by wx-out-0506.google.com with SMTP id h27so486257wxd.4
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2008 11:33:30 -0700 (PDT)
Message-ID: <43e72e890810241133s7af6958q5e889a81803555c3@mail.gmail.com> (sfid-20081024_203335_577036_76C96F19)
Date: Fri, 24 Oct 2008 11:33:30 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Marcel Holtmann" <marcel@holtmann.org>
In-Reply-To: <1224872780.3919.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1224585110.5521.8.camel@johannes.berg>
	 <1224816184.2917.162.camel@debian.sh.intel.com>
	 <1224841176.6002.124.camel@johannes.berg>
	 <20081024101518.GB5951@tesla> <1224872780.3919.3.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2008 at 11:26 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-10-24 at 03:15 -0700, Luis R. Rodriguez wrote:
>
>> >  * if a wiphy has the "hw regulatory" flag set and the
>> >    cfg80211_regdomain is the world regdomain (whether hard-coded or
>> >    gotten from CRDA)
>>
>> And if initiator == CORE
>
> Makes sense, yeah.

Now that i think about it, this would suffice for the check, no need
to check for world reg. Thoughts?

  Luis
