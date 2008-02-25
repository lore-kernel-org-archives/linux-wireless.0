Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:63811 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYBYOUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 09:20:32 -0500
Received: by an-out-0708.google.com with SMTP id d31so374609and.103
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 06:20:29 -0800 (PST)
Message-ID: <40f31dec0802250620u6db99db8tc6ddacab9422b734@mail.gmail.com> (sfid-20080225_142046_124846_3E6D6CAC)
Date: Mon, 25 Feb 2008 16:20:29 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
In-Reply-To: <20080225022336.GA8936@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224042851.GE4426@makis.domain.invalid>
	 <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
	 <20080224175933.GA4360@hash.localnet>
	 <40f31dec0802241548g6ffb13f3x122046a184eeeac9@mail.gmail.com>
	 <20080225022336.GA8936@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/25, Bob Copeland <me@bobcopeland.com>:
> > Some thoughts...
>  >
>  > It seems we are doing calibration wrong, i'll check out the other
>  > chips as well to come up with something, until then can you check out
>  > how does your card perform on b rates (eg. 11Mbits). Do an iperf test
>
>
> Hey, that's a good clue... I just switched over to b-only and it seems to
>  be much more stable.  It may be a few days before I can do the iperf tests,
>  gotta reconfigure my LAN somewhat.
>
>

If i'm correct you should get 4-7Mbit/sec @ 11Mbit. Plz let me know if
you have some results, meanwhile i'll try to figure out the i/q
calibration algo (we are ok for noise floor calibration i believe).


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
