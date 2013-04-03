Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760862Ab3DCXle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 19:41:34 -0400
Message-ID: <1365032488.8351.68.camel@jlt4.sipsolutions.net> (sfid-20130404_014137_667102_7BEA26AC)
Subject: Re: sta_info_flush_defer:  Splat in 3.9.0-rc5+
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 04 Apr 2013 01:41:28 +0200
In-Reply-To: <515CB8A3.50805@candelatech.com> (sfid-20130404_011800_128781_8C70A056)
References: <515CB8A3.50805@candelatech.com>
	 (sfid-20130404_011800_128781_8C70A056)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-03 at 16:17 -0700, Ben Greear wrote:
> I'm getting started on testing 3.9.0-rc5+ a bit more seriously.  This is on
> a tree with some additional patches:
> 
> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.9.dev.y/.git;a=summary
> 
> 
> The splat below comes from this.  I see lots of these on both station and AP system when
> bouncing 50 or so stations.

I might be interested if you can reproduce without your hashing patches,
but with those I suspect you just return an error there that shouldn't
be returned.

johannes

