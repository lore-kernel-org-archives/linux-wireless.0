Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56994 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754877AbcJVUaN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Oct 2016 16:30:13 -0400
Message-ID: <1477168206.4123.6.camel@sipsolutions.net> (sfid-20161022_223017_935583_C739AA7C)
Subject: Re: sequence diagrams in rst documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Date: Sat, 22 Oct 2016 22:30:06 +0200
In-Reply-To: <A533ED1D-9F0F-420D-9835-723F33D6CA83@darmarit.de>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
         <20161011072119.7ad4e3a3@lwn.net>
         <1476193466.4118.10.camel@sipsolutions.net>
         <1476194038.4118.11.camel@sipsolutions.net>
         <1476791021.6425.25.camel@sipsolutions.net>
         <20161018175236.75c8c4e2@lwn.net>
         <1476863488.5927.10.camel@sipsolutions.net>
         <1477053099.4068.42.camel@sipsolutions.net> <87k2d1q2qx.fsf@intel.com>
         <1477055055.4068.46.camel@sipsolutions.net>
         <EFAA684D-941C-45F9-8D37-F28EF3B11F4F@darmarit.de>
         <1477084793.4068.63.camel@sipsolutions.net>
         <A533ED1D-9F0F-420D-9835-723F33D6CA83@darmarit.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-10-22 at 18:37 +0200, Markus Heiser wrote:

> Yeah, I thought something similar. But is the import of the extension
> a sufficient criteria? 
> 
> About ".. math::"; I guess we have to check if math extension AND
> pdflatex is installed.
> 
> What do you suppose?

TBH, I only considered this briefly, but decided that somebody who went
to the effort of installing the sphinx extension would likely not mind
to get a subsequent error when it tries to use something that's not
installed.

I was, in fact, quite surprised that I even could install (on Debian)
the plantuml sphinx extension without plantuml, which seems odd.

In fact, I think it would be *preferable* to only check the extension ;
we should print a message from the dummy plugin to let them know what
extensions they need, and if they then go to the effort of installing
it they probably don't just not mind getting errors on dependencies,
but actually would *prefer* that, since otherwise it can be daunting to
try to figure out what *else* you actually have to install.

johannes
