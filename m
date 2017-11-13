Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53280 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752644AbdKMOxc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 09:53:32 -0500
Message-ID: <1510584810.30497.47.camel@sipsolutions.net> (sfid-20171113_155335_848061_25E7EDE1)
Subject: Re: [PATCH v2 3/4] cfg80211: reg: remove support for built-in regdb
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Date: Mon, 13 Nov 2017 15:53:30 +0100
In-Reply-To: <40a4b97b-7711-43d1-b0fb-3cfb7b8bca88@uni-rostock.de>
References: <20171009095018.5289-1-johannes@sipsolutions.net>
         <20171009095018.5289-4-johannes@sipsolutions.net>
         <5392a1bb-378c-17c6-de0d-862e86041c2e@uni-rostock.de>
         <1510564989.30497.5.camel@sipsolutions.net>
         <20171113133609.yfysyojr2mwlahfl@ubuntu-hedt>
         <fffbdcf1-631e-d0de-836d-e95266afa686@uni-rostock.de>
         <1510583813.30497.44.camel@sipsolutions.net>
         <b2023534-0ea0-b3b5-f6ef-40e5dd239d38@uni-rostock.de>
         <1510584253.30497.45.camel@sipsolutions.net>
         <40a4b97b-7711-43d1-b0fb-3cfb7b8bca88@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-11-13 at 15:48 +0100, Benjamin Beichler wrote:
> 
> Then this may be a bug, since the loading the regulatory.db fails
> (platform regulatory.0: Direct firmware load for regulatory.db failed
> with error -2) also, when CONFIG_CFG80211_REQUIRE_SIGNED_REGDB is not
> set (and of course CONFIG_CFG80211_CERTIFICATION_ONUS is set)

Well that just means you don't have the file (in the right place)

johannes
