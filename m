Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57196 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752210AbcKNJkc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 04:40:32 -0500
Message-ID: <1479116427.9766.1.camel@sipsolutions.net> (sfid-20161114_104048_849165_2D4FD2C0)
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
From: Johannes Berg <johannes@sipsolutions.net>
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org, btherthala@quantenna.com,
        hwang@quantenna.com, smaksimenko@quantenna.com,
        dlebed@quantenna.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Kyle McMartin <kyle@kernel.org>
Date: Mon, 14 Nov 2016 10:40:27 +0100
In-Reply-To: <a5075f50-25c6-18a1-bd5b-309927dacdab@quantenna.com>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
         <1478706966.18306.1.camel@sipsolutions.net>
         <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
         <1478725543.21403.4.camel@sipsolutions.net>
         <d1cfaf8a-55a6-3a7c-9e9d-ec810fe5b80d@quantenna.com>
         <1478864146.4129.4.camel@sipsolutions.net>
         <a5075f50-25c6-18a1-bd5b-309927dacdab@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-11-14 at 11:26 +0300, IgorMitsyanko wrote:
> Thanks, Johannes.
> 
> To clarify with you and Kalle, as persons involved with linux-
> wireless: is my understanding correct that submitting firmware into
> linux-fimware repository is a prerequisite to accepting new driver
> into linux-wireless?

I personally don't think it needs to be quite that strict, but I don't
think I've heard anyone else express an opinion either way.

Frankly, so far I only commented on the firmware patch because I
haven't had time to go over the driver code at all.

johannes
