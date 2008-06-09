Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:1641 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbYFIJCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 05:02:00 -0400
Received: by an-out-0708.google.com with SMTP id d40so470746and.103
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 02:01:59 -0700 (PDT)
Message-ID: <43e72e890806090201q55bff8e3m694121ebd4befee6@mail.gmail.com> (sfid-20080609_110203_092407_6DCE0788)
Date: Mon, 9 Jun 2008 02:01:58 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Backported MQ requirement on 802.11n for older kernels
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	compat-masters@lists.madwifi.org, tomas.winkler@intel.com,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1213001797.698.57.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890806080855p284f85brd0ff1f1dfce96bf8@mail.gmail.com>
	 <c85cb4470806090053l5b763a23j43bbf0c87f594b0d@mail.gmail.com>
	 <1213001797.698.57.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 9, 2008 at 1:56 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2008-06-09 at 10:53 +0300, Ron Rindjunsky wrote:
>> >
>> > I just finished trying to backport CONFIG_NETDEVICES_MULTIQUEUE
>> > requirement for 802.11n to older kernels by relying on the old
>> > internal mac80211 hacked up MQ support. I've tested the build on
>> > 2.6.22, 2.6.23, and 2.6.24. Let me know if you get to test this,
>> > particularly iwl4965 using 11n on 2.6.22.
>> >
>>
>> in config.mk you put MAC80211_QOS=m, and i guess that the intention was to put
>> CONFIG_MAC80211_QOS=m
>> if this is the case then the compilation fails
>
> It should be "y"
>
> johannes
>

Danke

  Luis
