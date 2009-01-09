Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:57981 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbZAIHzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 02:55:07 -0500
Received: by bwz14 with SMTP id 14so28537356bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 23:55:05 -0800 (PST)
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
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 09 Jan 2009 09:55:02 +0200
In-Reply-To: <1231432778.21643.40.camel@localhost.localdomain> (Dan Williams's message of "Thu\, 08 Jan 2009 11\:39\:38 -0500")
Message-ID: <87skns29t5.fsf@litku.valot.fi> (sfid-20090109_085514_380955_47BFFE05)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

>> Having the suspend scripts to tell NM to disconnect is just not a good
>> solution and especially in the embedded world this is a broken design
>> concept.
>
> Right; the missing piece is pushing the necessary roaming support down
> to the supplicant and letting it make the decisions about what to
> connect to.  There's a few things that I need from the supplicant before
> I can simply push the entire config set down from NM and let it go wild:
>
> 1) A 'frequency' config item that works in infrastructure mode too,
> ignoring any AP not matching that frequency

Just out of curiosity, why this feature is needed? I can understand
hard-coding bssid, but I don't understand the use for hard-coding the
frequency.

-- 
Kalle Valo
