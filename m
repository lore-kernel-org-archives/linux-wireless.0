Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56952 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751203AbcKIP4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 10:56:09 -0500
Message-ID: <1478706966.18306.1.camel@sipsolutions.net> (sfid-20161109_165613_060433_CBEC0CEA)
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
From: Johannes Berg <johannes@sipsolutions.net>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org, btherthala@quantenna.com,
        hwang@quantenna.com, smaksimenko@quantenna.com,
        dlebed@quantenna.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Wed, 09 Nov 2016 16:56:06 +0100
In-Reply-To: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-11-09 14:59, igor.mitsyanko.os@quantenna.com wrote:
> 
> [...]

So I'm told this thing actually runs a full Linux, and consequently is
(or at least contains) GPL code.

With the carl9170 driver, the GPL firmware was required to be put as
buildable source code into the linux-firmware tree.

What should happen here? I expect the sources for this to be pretty big
unlike carl9170 (1.1MB source).

johannes
