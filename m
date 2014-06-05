Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3267 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaFEK7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 06:59:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware debugging patches?
References: <53891ACD.7070902@candelatech.com>
	<87wqczz3h9.fsf@kamboji.qca.qualcomm.com>
	<538CA904.4000508@candelatech.com>
	<87ioojz1b1.fsf@kamboji.qca.qualcomm.com>
	<538CB782.1000509@candelatech.com> <538CC68C.10808@gmail.com>
	<538CC949.5020901@candelatech.com>
Date: Thu, 5 Jun 2014 13:58:49 +0300
In-Reply-To: <538CC949.5020901@candelatech.com> (Ben Greear's message of "Mon,
	2 Jun 2014 11:58:17 -0700")
Message-ID: <87fvjjpqqe.fsf@kamboji.qca.qualcomm.com> (sfid-20140605_125914_109229_6D2E9632)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> I am not sure this is really the case currently.  But, once the
> blob is generated and stored in RAM, it would be easily enough to
> add ethtool option to dump it w/out debugfs support.  This will
> still not really address my concerns because it may take a year
> or two for the latest ethtool binary to make it to normal-ish users.

[...]

> I think ethtool would not be overly hard to implement...basic framework is already
> in the wifi stack.

Few weeks back John Linville sent ethtool related patches to support
something like this. Did you notice that?

-- 
Kalle Valo
