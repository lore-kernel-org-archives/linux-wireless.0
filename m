Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33106 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932855AbcJUNEV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 09:04:21 -0400
Message-ID: <1477055055.4068.46.camel@sipsolutions.net> (sfid-20161021_150433_884224_68EF75F8)
Subject: Re: sequence diagrams in rst documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jani Nikula <jani.nikula@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc: linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>,
        Markus Heiser <markus.heiser@darmarit.de>
Date: Fri, 21 Oct 2016 15:04:15 +0200
In-Reply-To: <87k2d1q2qx.fsf@intel.com>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
         <20161011072119.7ad4e3a3@lwn.net>
         <1476193466.4118.10.camel@sipsolutions.net>
         <1476194038.4118.11.camel@sipsolutions.net>
         <1476791021.6425.25.camel@sipsolutions.net>
         <20161018175236.75c8c4e2@lwn.net>
         <1476863488.5927.10.camel@sipsolutions.net>
         <1477053099.4068.42.camel@sipsolutions.net> <87k2d1q2qx.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I had the same conclusion for math:: directives pulling in latex
> dependency [1]. Hopefully Markus can help here.

Yeah, good one.

Maybe it's actually simple? Depending on where sphinx will look for
plugins first, we could just ship the plugins with a no-op
implementation (pass through the text as pre-formatted text), and if it
finds the plugin first in a system-wide path that version would win for
the better rendering?

johannes
