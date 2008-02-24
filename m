Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:17468 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbYBXXs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 18:48:27 -0500
Received: by an-out-0708.google.com with SMTP id d31so315654and.103
        for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2008 15:48:27 -0800 (PST)
Message-ID: <40f31dec0802241548g6ffb13f3x122046a184eeeac9@mail.gmail.com> (sfid-20080224_234833_873277_DD4BA82C)
Date: Mon, 25 Feb 2008 01:48:26 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
In-Reply-To: <20080224175933.GA4360@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224042851.GE4426@makis.domain.invalid>
	 <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
	 <20080224175933.GA4360@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/24, Bob Copeland <me@bobcopeland.com>:
>  Then it works at least as well as I had it working (still with
>  random calibration failures, but I am again sending this mail using the
>  driver).

Some thoughts...

It seems we are doing calibration wrong, i'll check out the other
chips as well to come up with something, until then can you check out
how does your card perform on b rates (eg. 11Mbits). Do an iperf test
and see what you get eg. for 5.5M and 11M, we might force b-only mode
for these cards until we fix these issues (this would probably also
make rate control work).


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
