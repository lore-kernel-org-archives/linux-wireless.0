Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:40663 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab1FFIBa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 04:01:30 -0400
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcio.macedo@openbossa.org,
	aloisio.almeida@openbossa.org, sameo@linux.intel.com,
	Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [PATCH 2/6] NFC: add nfc generic netlink interface
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
	<1307051170-17374-3-git-send-email-lauro.venancio@openbossa.org>
	<1307108661.3800.6.camel@jlt3.sipsolutions.net>
	<BANLkTikS+cssYccjg_SfOhR15N=M9erw6Q@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 06 Jun 2011 11:01:23 +0300
In-Reply-To: <BANLkTikS+cssYccjg_SfOhR15N=M9erw6Q@mail.gmail.com> (Lauro Ramos Venancio's message of "Fri\, 3 Jun 2011 17\:18\:26 -0300")
Message-ID: <87ei378k30.fsf@purkki.adurom.net> (sfid-20110606_100134_106194_83AB0397)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lauro Ramos Venancio <lauro.venancio@openbossa.org> writes:

>> This is almost certainly not a good idea.
>>
>> Eventually, you will want to add more information about a target. I know
>> NFC is a pretty limited protocol, but I wouldn't want to make this
>> harder in the future than it must be. The way you're doing it, you're
>> currently limiting yourself to about 100 targets. Each new target
>> attribute that you might add in the future will reduce that number
>> significantly.
>
> Actually, we don't expect more than a couple of targets because of
> NFC short range.

This reminds me of Bill Gate's "640K ought to be enough for anybody"
quote (or misattribution, based on wikipedia). Better not to make any
assumptions based on the current state, instead make it extensible
enough so that the interface doesn't need to be redesigned in the next
few years.

-- 
Kalle Valo
