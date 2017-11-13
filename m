Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35031 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753624AbdKMNgM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 08:36:12 -0500
Received: from mail-io0-f197.google.com ([209.85.223.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eEEuJ-0007er-UB
        for linux-wireless@vger.kernel.org; Mon, 13 Nov 2017 13:36:12 +0000
Received: by mail-io0-f197.google.com with SMTP id u42so2296747ioi.7
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2017 05:36:11 -0800 (PST)
Date: Mon, 13 Nov 2017 07:36:09 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 3/4] cfg80211: reg: remove support for built-in regdb
Message-ID: <20171113133609.yfysyojr2mwlahfl@ubuntu-hedt> (sfid-20171113_143622_214298_3AC4C865)
References: <20171009095018.5289-1-johannes@sipsolutions.net>
 <20171009095018.5289-4-johannes@sipsolutions.net>
 <5392a1bb-378c-17c6-de0d-862e86041c2e@uni-rostock.de>
 <1510564989.30497.5.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1510564989.30497.5.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 13, 2017 at 10:23:09AM +0100, Johannes Berg wrote:
> On Mon, 2017-11-13 at 10:19 +0100, Benjamin Beichler wrote:
> > 
> > Is there already an example regulatory.db file available? 
> 
> There isn't yet, Seth?

Not yet. I've done some work on the patch you sent to make it generate
db files in both formats, not sure I'm ready to start actually releasing
files in the new format yet though. I suppose I could push it to a
testing branch with a signed regulatory.db file.

Seth
