Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab1D1LlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 07:41:16 -0400
Subject: Re: [PATCH wireless-2.6] iwlagn: fix "Received BA when not
 expected"
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1303990661.3558.3.camel@jlt3.sipsolutions.net> (sfid-20110428_133751_772868_CCD82590)
References: <20110428111011.GA6967@redhat.com>
	 <1303990661.3558.3.camel@jlt3.sipsolutions.net>
	 (sfid-20110428_133751_772868_CCD82590)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 13:41:11 +0200
Message-ID: <1303990871.3558.5.camel@jlt3.sipsolutions.net> (sfid-20110428_134118_773847_093EB0D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-28 at 13:37 +0200, Johannes Berg wrote:
> On Thu, 2011-04-28 at 13:10 +0200, Stanislaw Gruszka wrote:
> > Need to use broadcast sta_id for management and multicast frames,
> > otherwise we broke BA session and get messages like that:
> > 
> > "Received BA when not expected"
> > 
> > or (on older kernels):
> > 
> > "BA scd_flow 0 does not match txq_id 10"
> 
> Hmm. Interesting. I believe you, but it's hard.

You're right of course that my patch changed the behaviour. I just don't
(yet) understand why it's causing this particular issue.

johannes


