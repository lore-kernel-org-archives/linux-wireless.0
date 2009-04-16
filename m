Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:38973 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbZDPGQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 02:16:51 -0400
Received: by bwz17 with SMTP id 17so220424bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 23:16:49 -0700 (PDT)
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Subject: Re: [PATCH 2/7] ath5k: Read Spur channels from EEPROM
References: <20090416002449.GB4138@makis>
	<1239841547.25334.19.camel@johannes.local>
	<40f31dec0904151751u3fd15d93i194d0abbb4657439@mail.gmail.com>
	<1239843860.4669.1.camel@johannes.local> <49E6CCBA.2010105@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 09:16:47 +0300
In-Reply-To: <49E6CCBA.2010105@gmail.com> (Jiri Slaby's message of "Thu\, 16 Apr 2009 08\:14\:18 +0200")
Message-ID: <87k55lf7hs.fsf@litku.valot.fi> (sfid-20090416_081654_517897_CEE4D1BA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Slaby <jirislaby@gmail.com> writes:

> On 04/16/2009 03:04 AM, Johannes Berg wrote:
>> On Thu, 2009-04-16 at 03:51 +0300, Nick Kossifidis wrote:
>>> ACK, are 80 cols ok ?
>> 
>> I don't know if there's a standard on that, I tend to use around 60-70,
>> but 80 seems good too. It's not just the "doesn't fit terminal" argument
>> anyway, it's much easier to read if it's less.
>
> When one uses git log, it gets moved few (4) columns to the right. So
> something little less than 76 is usually preferred :).

I think in usenet 72 characters was the recommended width, right? That
way quoting was also easier.

-- 
Kalle Valo
