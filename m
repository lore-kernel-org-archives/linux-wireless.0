Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:54185 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab0AWAJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 19:09:48 -0500
MIME-Version: 1.0
In-Reply-To: <1264152878.11396.82.camel@johannes.local>
References: <20100121230600.GC8069@bombadil.infradead.org>
	<1264152878.11396.82.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 22 Jan 2010 16:09:27 -0800
Message-ID: <43e72e891001221609jd2fcb90q1ee46d266d9227f1@mail.gmail.com>
Subject: Re: [RFC/RFT v2]: compat-wireless for 2.6.32.4 - multiqueue backport
	support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 22, 2010 at 1:34 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-01-21 at 18:06 -0500, Luis R. Rodriguez wrote:
>
>> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
>> +static bool ieee80211_all_queues_stopped(struct ieee80211_hw *hw)
>
> You want "all queues started" :)

Whoops, yeah thanks, will fix.

  Luis
