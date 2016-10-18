Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:51852 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761702AbcJRN7s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 09:59:48 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: sequence diagrams in rst documentation
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <1476791021.6425.25.camel@sipsolutions.net>
Date: Tue, 18 Oct 2016 15:51:39 +0200
Cc: Jonathan Corbet <corbet@lwn.net>, linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Message-Id: <B9AC83F3-AA14-414B-B538-81436620E432@darmarit.de> (sfid-20161018_155952_156988_98798AF0)
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net> <20161011072119.7ad4e3a3@lwn.net> <1476193466.4118.10.camel@sipsolutions.net> <1476194038.4118.11.camel@sipsolutions.net> <1476791021.6425.25.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Am 18.10.2016 um 13:43 schrieb Johannes Berg <johannes@sipsolutions.net>:

> On Tue, 2016-10-11 at 15:53 +0200, Johannes Berg wrote:
>>> 
>>> 
>>> Related question: I have some sequence diagrams, and just found the
>>> seqdiag sphinx plugin. How should we manage adding extensions? Or
>>> would you prefer not to add any at all?
>> 
>> Example here:
>> https://johannes.sipsolutions.net/files/80211/mac80211.html#connection-flow
> 
> Coming back to this - sadly, it appears that this software (blockdiag,
> seqdiag) is completely unmaintained, with open pull requests dating
> back to 2012 and the last commit dating back to 2015-08-22.
> 
> I'd want/need feature improvements in it too, but if I can't feed those
> back to upstream (since it appears dead), there's little point.
> 
> Perhaps we can ship plugins for this as part of the kernel sources?
> Shouldn't be too difficult to reimplement something like this, after
> all.

Here are my thoughts ...

Every extension which is not a part of the sphinx distro brings new
external dependencies and the development of such extensions is IMO
far of kernel development's scope.

ATM, there are not many use cases for diagram generators, so why not
be KISS and creating diagrams with the favorite tool only adding the
resulting (e.g.) PNG to the Kernel's source?

Before we add new dependencies / complexity, we should get rid
of the DocBook build.

-- Markus --


> johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
