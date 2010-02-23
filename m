Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55500 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0BWTfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 14:35:39 -0500
Received: by pwj8 with SMTP id 8so4110387pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2010 11:35:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266938710.3934.7.camel@jlt3.sipsolutions.net>
References: <201002231619.55189.helmut.schaa@googlemail.com>
	<1266938710.3934.7.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 23 Feb 2010 11:35:19 -0800
Message-ID: <43e72e891002231135p5a9957f7i15d5df94ce05ab8c@mail.gmail.com>
Subject: Re: [RFC] Improve software scan timing
To: Johannes Berg <johannes@sipsolutions.net>,
	mark gross <mgross@linux.intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2010 at 7:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-02-23 at 16:19 +0100, Helmut Schaa wrote:
>
>> However I've got a few open questions:
>>
>> Does anybody know if pm_qos is already used by any applications? At
>> least on my system it seems that nothing sets any latency requirements.
>
> Yeah, it doesn't seem to be used...

Just to be safe, Mark, know of any userspace applications using pm-qos
for latency yet?

  Luis
