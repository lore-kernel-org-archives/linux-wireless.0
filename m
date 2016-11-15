Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48848 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751693AbcKONm0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 08:42:26 -0500
Message-ID: <1479217343.12007.31.camel@sipsolutions.net> (sfid-20161115_144229_291990_F43E6761)
Subject: Re: [PATCH] fixed hwsim beacon delta calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Date: Tue, 15 Nov 2016 14:42:23 +0100
In-Reply-To: <980aa1f8-42c3-4fe4-a930-d930474ad2eb@MAIL1.uni-rostock.de>
References: <980aa1f8-42c3-4fe4-a930-d930474ad2eb@MAIL1.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-11-11 at 17:37 +0100, Benjamin Beichler wrote:
> Due to the cast from uint32_t to int64_t, a wrong next beacon timing
> is
> calculated and effectively the beacon timer stops to work. This is
> especially bad for 802.11s mesh networks, because discovery breaks
> without beacons.
> 
Applied. Please note how I changed the commit subject, and use that
scheme in the future.

johannes
