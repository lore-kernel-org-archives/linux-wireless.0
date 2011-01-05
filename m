Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23723 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab1AES3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 13:29:10 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 10:28:41 -0800
Date: Wed, 5 Jan 2011 10:28:38 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Kathy Giori <Kathy.Giori@Atheros.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	David Quan <David.Quan@Atheros.com>,
	Michael Green <Michael.Green@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/8] wireless: DFS region support
Message-ID: <20110105182838.GC10391@tux>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
 <20110104184928.GA13239@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110104184928.GA13239@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 04, 2011 at 10:49:28AM -0800, John W. Linville wrote:
> On Mon, Dec 20, 2010 at 12:02:26PM -0500, Luis R. Rodriguez wrote:
> > This series has a list of changes to kernel and userspace to start addressing
> > DFS region support. I've cheated and figured out a way to alter the current
> > regulatory database in such a way that it remains backwards compatible with
> > older databases so that no new CRDAs are required and we don't have to provide
> > two releases for old kernels and newer kernels for wireless-regdb updates.
> > 
> > In the end we end up passing the DFS region to the drivers. In terms of our DFS
> > development roadmap this covers parts I and II as promissed that I would take care
> > of by tomorrow, and leaves open now the chance for developers to start working
> > on part III: "Where do we stuff DFS parameters for each region":
> > 
> > http://wireless.kernel.org/en/developers/DFS
> > 
> > In tomorrow's meeting we can cover who is going to work on part III. People who
> > want to work on part III can start using these patches on their systems.
> > 
> > John, lets wait to merge these until Wednesday, I post these in patch form as I
> > think they are ready but tomorrow's discussions may push us to alter this a
> > bit, not sure. I will also review what we have done here with Michael Green so
> > he is on the same page.
> 
> Well, now there has been plenty of time to reflect...comments? :-)

I'll reduce the number of bits to 8 instead of 16 for the DFS regions, I'll also
try to schedule a call with Michael to finalize his review on this and then I'll
respin and submit again.

  Luis
