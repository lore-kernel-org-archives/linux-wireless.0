Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:30315 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbYCKQr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 12:47:58 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2928291wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2008 09:47:56 -0700 (PDT)
Subject: Re: [PATCH 3/5] mac80211: replace Mk16 helper with le16_to_cpup
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1205252069.6387.52.camel@johannes.berg>
References: <1204968187.23455.39.camel@brick>
	 (sfid-20080308_092339_300656_E96B3B6F)  <1205252069.6387.52.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 09:21:33 -0700
Message-Id: <1205252493.22317.3.camel@brick> (sfid-20080311_164801_253585_9BB4366D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-03-11 at 17:14 +0100, Johannes Berg wrote:
> On Sat, 2008-03-08 at 01:23 -0800, Harvey Harrison wrote:
> > Opencoded byte-swapping could just use the kernel helper.
> 
> > +	p1k[2] = le16_to_cpup(leptr++);
> 
> I'm ok with this if architectures guarantee that these operations work
> on unaligned values, but I don't think that is the case.
> 

I'm looking into this, but I'm pretty sure this isn't right as-is.

I wasn't thinking about alignment at the time, just ignore this.

Harvey

