Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41694 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760842AbaCURaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 13:30:25 -0400
Message-ID: <532C7710.1050102@candelatech.com> (sfid-20140321_183032_688355_7FB01787)
Date: Fri, 21 Mar 2014 10:29:52 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Fix getting stats from firmware.
References: <1395360324-20433-1-git-send-email-greearb@candelatech.com> <CA+BoTQn1B6g19Ks41kzcoVyhYbHAcJGTNAyucmPMupbRAy1SNg@mail.gmail.com> <CAEFj98541uEFjHxjzUeim4nrjELToYrnbJTGuR5WgzwRvF9gkw@mail.gmail.com> <532C62DE.6060309@candelatech.com> <87eh1va5um.fsf@kamboji.qca.qualcomm.com> <CAEFj985WKAOp9vewgZW8LYB9KdUxh2GJG5uhAjRdCSiAd-y1sQ@mail.gmail.com>
In-Reply-To: <CAEFj985WKAOp9vewgZW8LYB9KdUxh2GJG5uhAjRdCSiAd-y1sQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2014 09:42 AM, Yeoh Chun-Yeow wrote:
> Hi, Ben
> 
> I did a quick check again on STA mode. With or without your patch, the
> printed peer stats are both identical but both wrong. See below:

Ok, it's unlikely my patch would have changed it one way or another.

I'll leave my patch mostly as it was (ie, no special handling for
older v/s newer firmware).

I am just starting to look at stats, and since 10.x was completely
broken and has been for some time, probably no one else has paid
much attention to it yet either.

Thanks for testing.

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

