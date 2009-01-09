Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:35655 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZAIQo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 11:44:28 -0500
Received: by bwz14 with SMTP id 14so29234822bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 08:44:26 -0800 (PST)
To: Dan Williams <dcbw@redhat.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	<1229336057.4471.9.camel@johannes.berg>
	<1229354532.12163.24.camel@localhost.localdomain>
	<20081217174244.M36761@bobcopeland.com>
	<1230064216.31228.46.camel@johannes>
	<20081224054951.GA32398@hash.localnet>
	<1230102989.16960.14.camel@californication>
	<1231260306.14565.21.camel@localhost.localdomain>
	<1231261937.5246.16.camel@californication>
	<1231267979.14565.34.camel@localhost.localdomain>
	<1231270575.14901.6.camel@californication>
	<1231432778.21643.40.camel@localhost.localdomain>
	<87skns29t5.fsf@litku.valot.fi>
	<1231518921.30057.14.camel@dhcp-18-190-61-35.dyn.mit.edu>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 09 Jan 2009 18:44:19 +0200
In-Reply-To: <1231518921.30057.14.camel@dhcp-18-190-61-35.dyn.mit.edu> (Dan Williams's message of "Fri\, 09 Jan 2009 11\:35\:21 -0500")
Message-ID: <878wpktonw.fsf@litku.valot.fi> (sfid-20090109_174432_810417_C852F6F9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> On Fri, 2009-01-09 at 09:55 +0200, Kalle Valo wrote:
>> Dan Williams <dcbw@redhat.com> writes:
>> 
>> > 1) A 'frequency' config item that works in infrastructure mode too,
>> > ignoring any AP not matching that frequency
>> 
>> Just out of curiosity, why this feature is needed? I can understand
>> hard-coding bssid, but I don't understand the use for hard-coding the
>> frequency.
>
> If the user wishes to lock the connection to a specific frequency,
> irregardless of other values.

I guessed that part :) But I wanted to ask why would user want to do
this? I don't see any benefits from that.

> Maybe you're right and we don't really care about it, but one other
> thing that would be nice is a "band" argument for a network block to
> differentiate A vs. B/G APs that might have the same SSID and
> security settings, but where the user only wants to use the A-side
> for example.

This would be nice to have, most probably I would immediately disable
A band just to get faster scanning. I don't use 802.11a anywhere, for
me it's useless.

-- 
Kalle Valo
