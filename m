Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:54578 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731577AbeHGIgZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Aug 2018 04:36:25 -0400
Message-ID: <7a6298921f401b59bab1488f2596e3b1b5f78551.camel@strongswan.org> (sfid-20180807_082342_207287_8FCCEC25)
Subject: Re: ath10k SWBA overrun / tx credit starvation
From: Martin Willi <martin@strongswan.org>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Aug 2018 08:23:36 +0200
In-Reply-To: <9ce7eaed-d842-45e7-4a2a-ae2bc0f72fe5@candelatech.com>
References: <6f044fff274867c90038e673c9291279ae1a1121.camel@strongswan.org>
         <8b65a418-04ba-620d-8139-ac62d6715b24@candelatech.com>
         <1c41320da3c241aed1281576eace6021ccb3adb0.camel@strongswan.org>
         <9ce7eaed-d842-45e7-4a2a-ae2bc0f72fe5@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > [...], which implies that at least some of them have been addressed
> > with 10.2/10.2.4.
> 
> Out of curiosity, how soon could you hit it with -ct firmware?  We
> often see these around once per day in some of our test cases, rarely
> more often than that.

I have no hard numbers, as I have no reproducer. In the field this
depends on the client load, but once in 1-3 days is realistic.

With 10.2.4 is see this much less frequent (factor 10).

Martin
