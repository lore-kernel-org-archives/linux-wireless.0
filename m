Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46952 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbeB0WTR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 17:19:17 -0500
Received: from mail-it0-f72.google.com ([209.85.214.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eqnae-0001df-7W
        for linux-wireless@vger.kernel.org; Tue, 27 Feb 2018 22:19:16 +0000
Received: by mail-it0-f72.google.com with SMTP id a79so806877itc.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 14:19:16 -0800 (PST)
Date: Tue, 27 Feb 2018 16:19:13 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH v2 11/13] cfg80211: read wmm rules from regulatory
 database
Message-ID: <20180227221913.GD4617@ubuntu-xps13> (sfid-20180227_231921_524485_B19A73D1)
References: <20180219124847.27169-1-luca@coelho.fi>
 <20180219124847.27169-12-luca@coelho.fi>
 <1519047033.16723.14.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1519047033.16723.14.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 19, 2018 at 02:30:33PM +0100, Johannes Berg wrote:
> On Mon, 2018-02-19 at 14:48 +0200, Luca Coelho wrote:
> > From: Haim Dreyfuss <haim.dreyfuss@intel.com>
> > 
> > ETSI EN 301 893 v211 (2017-05) standard defines a new channel access
> > mechanism that all devices (WLAN and LAA) need to comply with.
> > The regulatory database can now be loaded into the kernel and also
> > has the option to load optional data.
> > In order to be able to comply with ETSI standard, we add wmm_rule into
> > regulatory rule and add the option to read its value from the regulatory
> > database.
> 
> Seth, this is going to come with an update to the regdb as well. I'd
> appreciate if you could take a look.

I think it looks okay, but I guess there will be new patches so I will
take another look then. Is there an example of the db.txt updates for
the WMM rules?

Seth
