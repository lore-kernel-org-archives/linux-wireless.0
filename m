Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:53014 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZFLXd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 19:33:29 -0400
Received: by ewy6 with SMTP id 6so3424312ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2009 16:33:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244848193-11210-1-git-send-email-andrey@cozybit.com>
References: <1244848193-11210-1-git-send-email-andrey@cozybit.com>
Date: Sat, 13 Jun 2009 02:33:30 +0300
Message-ID: <40f31dec0906121633n1dd72353ied2a2c2e57565233@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fix mesh beaconing
From: Nick Kossifidis <mickflemm@gmail.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/13 Andrey Yurovsky <andrey@cozybit.com>:
> This patch is from Nick Kossifidis but he forgot to send it.  It ensures
> that the beacon queue gets started in mesh mode as well, otherwise ath5k
> will not beacon in mesh point mode.
>
> At this time, we still need to issue a scan before mesh beaconing will
> work but that appears to be a separate problem.
>
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Sorry for the delay, i had to deal with various stuff...
Thanks for testing this and sending the patch ;-)

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
