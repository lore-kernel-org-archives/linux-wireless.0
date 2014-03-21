Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50125 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaCUQMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 12:12:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Fix getting stats from firmware.
References: <1395360324-20433-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQn1B6g19Ks41kzcoVyhYbHAcJGTNAyucmPMupbRAy1SNg@mail.gmail.com>
	<CAEFj98541uEFjHxjzUeim4nrjELToYrnbJTGuR5WgzwRvF9gkw@mail.gmail.com>
	<532C62DE.6060309@candelatech.com>
Date: Fri, 21 Mar 2014 18:12:17 +0200
In-Reply-To: <532C62DE.6060309@candelatech.com> (Ben Greear's message of "Fri,
	21 Mar 2014 09:03:42 -0700")
Message-ID: <87eh1va5um.fsf@kamboji.qca.qualcomm.com> (sfid-20140321_171228_646440_65154FE8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 03/20/2014 11:41 PM, Yeoh Chun-Yeow wrote:
>>>
>>> Did you test 636 as well? 636 doesn't seem to support more than just `stats_id`.
>>>
>> Nope. Tested with 636 not working.
>
> Does the existing code work with 636?  If so, we can add two different cmd
> structs and use the smaller one with 636, and the one I modified with
> 10.x firmware?

For this issue that would be the best approach. See Marek P's patch
"ath10k: update regulatory domain settings for 10.x firmware" (not yet
applied, still in ath-next-test branch) as an example how this can be
done.

-- 
Kalle Valo
