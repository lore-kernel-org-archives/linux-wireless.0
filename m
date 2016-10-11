Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:47214 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbcJKNsk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2016 09:48:40 -0400
Date: Tue, 11 Oct 2016 07:21:19 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] docs-rst: sphinxify 802.11 documentation
Message-ID: <20161011072119.7ad4e3a3@lwn.net> (sfid-20161011_154846_376457_C25A0052)
In-Reply-To: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 11 Oct 2016 14:56:53 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> This is just a very basic conversion, I've split up the original
> multi-book template, and also split up the multi-part mac80211
> part in the original book; neither of those were handled by the
> automatic pandoc conversion.
> 
> Fix errors that showed up, resulting in a much nicer rendering,
> at least for the interface combinations documentation.

Great, this is just what I want to see - another DocBook template gone!

> Jon, unless you have strong objections, I'd like to take this
> through my tree due to the header file changes.

Is there any chance of splitting those two things up?  In particular,
index.rst has become a real conflict point, and I'm getting tired of
explaining those to Linus...so I'd prefer to carry that part if possible.

Thanks,

jon
