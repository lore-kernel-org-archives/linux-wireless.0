Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39527 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaCUQEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 12:04:10 -0400
Message-ID: <532C62DE.6060309@candelatech.com> (sfid-20140321_170415_810137_5B0206CA)
Date: Fri, 21 Mar 2014 09:03:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Fix getting stats from firmware.
References: <1395360324-20433-1-git-send-email-greearb@candelatech.com> <CA+BoTQn1B6g19Ks41kzcoVyhYbHAcJGTNAyucmPMupbRAy1SNg@mail.gmail.com> <CAEFj98541uEFjHxjzUeim4nrjELToYrnbJTGuR5WgzwRvF9gkw@mail.gmail.com>
In-Reply-To: <CAEFj98541uEFjHxjzUeim4nrjELToYrnbJTGuR5WgzwRvF9gkw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2014 11:41 PM, Yeoh Chun-Yeow wrote:
>>
>> Did you test 636 as well? 636 doesn't seem to support more than just `stats_id`.
>>
> Nope. Tested with 636 not working.

Does the existing code work with 636?  If so, we can add two different cmd
structs and use the smaller one with 636, and the one I modified with
10.x firmware?

Thanks,
Ben

> 
> ----
> Chun-Yeow
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

