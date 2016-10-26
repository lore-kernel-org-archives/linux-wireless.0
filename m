Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49902 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751802AbcJZI4G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 04:56:06 -0400
Message-ID: <1477472104.4059.21.camel@sipsolutions.net> (sfid-20161026_105820_028812_9C22AEF6)
Subject: Re: [PATCH 2/2] mac80211: use inline kernel-doc for struct
 ieee80211_hw
From: Johannes Berg <johannes@sipsolutions.net>
To: Jani Nikula <jani.nikula@intel.com>, linux-wireless@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Date: Wed, 26 Oct 2016 10:55:04 +0200
In-Reply-To: <87bmy7mrq1.fsf@intel.com>
References: <1477054644-5945-1-git-send-email-jani.nikula@intel.com>
         <1477054644-5945-2-git-send-email-jani.nikula@intel.com>
         <1477462177.4059.19.camel@sipsolutions.net> <87bmy7mrq1.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-26 at 11:36 +0300, Jani Nikula wrote:
> On Wed, 26 Oct 2016, Johannes Berg <johannes@sipsolutions.net> wrote:
> > 
> > On Fri, 2016-10-21 at 15:57 +0300, Jani Nikula wrote:
> > > 
> > > It's easier to manage the kernel-doc for the fields when they
> > > documentation is next to the field.
> > 
> > Ok, actually, this doesn't apply. Perhaps I'll look into scripting
> > this
> > kind of conversion.
> 
> No problem; I'll leave it up to you.

I'll probably end up doing it manually though - no chance I can extend
the parser to output an spatch (doing the comment placement with spatch
actually works, but getting there...)
