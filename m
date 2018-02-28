Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59150 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbeB1IGI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 03:06:08 -0500
Message-ID: <1519805163.2292.0.camel@sipsolutions.net> (sfid-20180228_090618_139764_6C7880B1)
Subject: Re: [PATCH v2 11/13] cfg80211: read wmm rules from regulatory
 database
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Feb 2018 09:06:03 +0100
In-Reply-To: <20180227221913.GD4617@ubuntu-xps13>
References: <20180219124847.27169-1-luca@coelho.fi>
         <20180219124847.27169-12-luca@coelho.fi>
         <1519047033.16723.14.camel@sipsolutions.net>
         <20180227221913.GD4617@ubuntu-xps13>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-02-27 at 16:19 -0600, Seth Forshee wrote:
> 
> I think it looks okay, but I guess there will be new patches so I will
> take another look then. Is there an example of the db.txt updates for
> the WMM rules?

I'm not sure we have a full db.txt update yet, but Haim definitely has
a patch for the parser, and will send them out soon :)

johannes
