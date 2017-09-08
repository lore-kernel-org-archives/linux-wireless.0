Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36742 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753183AbdIHOTW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 10:19:22 -0400
Message-ID: <1504880360.20347.0.camel@sipsolutions.net> (sfid-20170908_161952_339051_D99DE475)
Subject: Re: [RFC 3/4] mac80211_hwsim: explicitly set netlink parallel ops
 to false
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Date: Fri, 08 Sep 2017 16:19:20 +0200
In-Reply-To: <593fec4f-fc0c-4610-b144-35760ee92102@MAIL1.uni-rostock.de>
References: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de>
         <593fec4f-fc0c-4610-b144-35760ee92102@MAIL1.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-08 at 16:11 +0200, Benjamin Beichler wrote:
> The ops field is zero initialized, therefore parallel ops is already
> false.

Therefore this patch is completely pointless?

johannes
