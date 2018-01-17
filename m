Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40772 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752446AbeAQNM1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 08:12:27 -0500
Message-ID: <1516194744.410.54.camel@sipsolutions.net> (sfid-20180117_141241_933126_51F7B688)
Subject: Re: UBSAN: Undefined behaviour in net/wireless/nl80211.c:718:4:
 -1665903437 * 100 cannot be represented in type 'int'
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        it+linux-wireless@molgen.mpg.de,
        Mario Limonciello <mario.limonciello@dell.com>,
        Thorsten Leemhuis <linux@leemhuis.info>
Date: Wed, 17 Jan 2018 14:12:24 +0100
In-Reply-To: <b1e1592a-d975-dbc5-b3a3-6b97d9df0643@molgen.mpg.de>
References: <f58ac367-9b22-a7dc-7d45-7e9d19e179c0@molgen.mpg.de>
         <1515078514.10342.29.camel@sipsolutions.net>
         <b1e1592a-d975-dbc5-b3a3-6b97d9df0643@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-17 at 13:22 +0100, Paul Menzel wrote:
> 
> Yes it does. Thank you. Rebuilding Linux 4.15-rc8+ with this patch 
> applied, the UBSAN doesn’t report this issue anymore.

Thanks for testing, the patch is on its way to get to 4.15 (hopefully)

johannes
