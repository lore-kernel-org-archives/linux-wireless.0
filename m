Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:26473 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbYIPIIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 04:08:36 -0400
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Helmut Schaa" <hschaa@suse.de>, "Dan Williams" <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Jouni Malinen" <j@w1.fi>
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
References: <200809151416.07552.hschaa@suse.de>
	<200809151634.06448.hschaa@suse.de>
	<1221492529.10177.76.camel@localhost.localdomain>
	<200809151845.35841.hschaa@suse.de>
	<43e72e890809151821h5d40e750q10c78f4d20d27c79@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 16 Sep 2008 11:07:35 +0300
In-Reply-To: <43e72e890809151821h5d40e750q10c78f4d20d27c79@mail.gmail.com> (ext Luis R. Rodriguez's message of "Mon\, 15 Sep 2008 18\:21\:17 -0700")
Message-ID: <87r67kzf7c.fsf@nokia.com> (sfid-20080916_100844_742738_D3E5EF9B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@gmail.com> writes:

> On Mon, Sep 15, 2008 at 9:45 AM, Helmut Schaa <hschaa@suse.de> wrote:
>
>> Ok, I'll sum that up. Moving the policy into user space is a good
>> thing if the quality values are comparable. Once mac80211
>> recognices a noticable quality change we could use IWEVQUAL to
>> notify user space about it. Furthermore (if desired) the signal
>> could be extended to not only report a value between 0 and 100 but
>> could also contain flags indicating lost beacons, excessive retries
>> etc.
>
> If you are going to add a new sort of notification can you please use
> nl80211? No need to keep wireless extensions on life support.

>From my point of view WE is not on life support (yet) but instead very
widely used. As an example, I still haven't seen any cfg80211/nl80211
user space tools in debian unstable. (Please correct me if I'm wrong.)
There has been a lot of talk about cfg80211/nl80211 but unfortunately
the migration progress has been very slow.

I definitely want to see this background scan support in Wireless
Extensions as well, otherwise it might prevent the real use of the
feature.

-- 
Kalle Valo
