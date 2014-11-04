Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40599 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaKDNBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 08:01:00 -0500
Message-ID: <1415106058.11912.9.camel@umadbro> (sfid-20141104_140123_010490_B454B338)
Subject: Re: [PATCH] cfg80211: Move join/leave_ocb comments to be in the
 correct order
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	fengguang.wu@intel.com,
	Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Tue, 04 Nov 2014 14:00:58 +0100
In-Reply-To: <1415105716.2064.17.camel@sipsolutions.net>
References: <1415105352-4295-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20141104_134918_159065_C641379A) <1415105716.2064.17.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-04 at 13:55 +0100, Johannes Berg wrote:
> On Tue, 2014-11-04 at 13:49 +0100, Rostislav Lisovy wrote:
> > Use the same ordering in the comments section as it
> > is in the structure below.
> 
> Well, I think I confused you :-)
> The report from Fengguang's build bot was actually when there was no
> documentation, and then I added it and I guess you thought that it was
> sending out the report because it was in the wrong place?
> 
> Anyway, I think I'll just leave it as is, and not apply this, ok?

Yes, that is what I thought. The second confusion was that most of the
other comments were not in the same order as their fields.

Ok, no need to apply this.

Rostislav

