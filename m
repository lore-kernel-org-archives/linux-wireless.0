Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:37965 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712AbYJJSWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 14:22:14 -0400
Received: by yx-out-2324.google.com with SMTP id 8so232951yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 11:22:13 -0700 (PDT)
Message-ID: <43e72e890810101122o12440c60ic35b19b037bf95de@mail.gmail.com> (sfid-20081010_202217_306951_CDA3B7AE)
Date: Fri, 10 Oct 2008 11:22:13 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/8] mac80211: remove aggregation status write support from debugfs
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Andrey Yurovsky" <andrey@cozybit.com>
In-Reply-To: <1223452772.3618.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081007100428.868688000@sipsolutions.net>
	 <20081007100438.773792000@sipsolutions.net>
	 <1ba2fa240810071424s23bdbbb7kbaadf3678cd61a26@mail.gmail.com>
	 <1223452772.3618.20.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 8, 2008 at 12:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-10-07 at 23:24 +0200, Tomas Winkler wrote:
>> On Tue, Oct 7, 2008 at 12:04 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > This code uses static variables and thus cannot be kept.
>> NACK
>> Need something to debug this stuff
>
> Tough luck. Go write proper support in nl80211 then.

Someone has some patch to use nl80211 for this BTW. *cough*

  Luis
