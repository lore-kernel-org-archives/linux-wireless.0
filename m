Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50812 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752666AbeBSNaf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 08:30:35 -0500
Message-ID: <1519047033.16723.14.camel@sipsolutions.net> (sfid-20180219_143039_562560_FC9985B4)
Subject: Re: [PATCH v2 11/13] cfg80211: read wmm rules from regulatory
 database
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>,
        Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Feb 2018 14:30:33 +0100
In-Reply-To: <20180219124847.27169-12-luca@coelho.fi>
References: <20180219124847.27169-1-luca@coelho.fi>
         <20180219124847.27169-12-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-19 at 14:48 +0200, Luca Coelho wrote:
> From: Haim Dreyfuss <haim.dreyfuss@intel.com>
> 
> ETSI EN 301 893 v211 (2017-05) standard defines a new channel access
> mechanism that all devices (WLAN and LAA) need to comply with.
> The regulatory database can now be loaded into the kernel and also
> has the option to load optional data.
> In order to be able to comply with ETSI standard, we add wmm_rule into
> regulatory rule and add the option to read its value from the regulatory
> database.

Seth, this is going to come with an update to the regdb as well. I'd
appreciate if you could take a look.

Thanks,
johannes
