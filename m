Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58044 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZHAShd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 14:37:33 -0400
Received: by bwz19 with SMTP id 19so1742856bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2009 11:37:33 -0700 (PDT)
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Subject: Re: [PATCH 1/4]: Check EEPROM before tweaking SERDES
References: <20090731180238.GA7963@makis>
	<43e72e890907311111k10cce08et84510866c68e0297@mail.gmail.com>
	<40f31dec0907311118o5460952xd3462b14375eeb72@mail.gmail.com>
	<43e72e890907311120r76d3db6et91128ccbc3a90c63@mail.gmail.com>
	<40f31dec0907311127o4bc4de73u1b4b5dfeb66d55b9@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 01 Aug 2009 21:37:30 +0300
In-Reply-To: <40f31dec0907311127o4bc4de73u1b4b5dfeb66d55b9@mail.gmail.com> (Nick Kossifidis's message of "Fri\, 31 Jul 2009 21\:27\:51 +0300")
Message-ID: <87ljm3nzx1.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis <mickflemm@gmail.com> writes:

>> Yes, but my point is a move can be done in one patch, changes to that
>> code in a separate patch, to help understand what is going on during
>> patch review.
>
> I think this will pollute the logs, it's a very simple change and commented.

I'm with Luis here. It makes a lot easier to read patches and find bugs
if the patches do one thing at a time. Don't worry about the number of
patches, usually that's not a problem.

-- 
Kalle Valo
