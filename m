Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36781 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1ADTAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 14:00:06 -0500
Date: Tue, 4 Jan 2011 13:49:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: kathy.giori@atheros.com, amod.bodas@atheros.com,
	david.quan@atheros.com, michael.green@atheros.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] wireless: DFS region support
Message-ID: <20110104184928.GA13239@tuxdriver.com>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 20, 2010 at 12:02:26PM -0500, Luis R. Rodriguez wrote:
> This series has a list of changes to kernel and userspace to start addressing
> DFS region support. I've cheated and figured out a way to alter the current
> regulatory database in such a way that it remains backwards compatible with
> older databases so that no new CRDAs are required and we don't have to provide
> two releases for old kernels and newer kernels for wireless-regdb updates.
> 
> In the end we end up passing the DFS region to the drivers. In terms of our DFS
> development roadmap this covers parts I and II as promissed that I would take care
> of by tomorrow, and leaves open now the chance for developers to start working
> on part III: "Where do we stuff DFS parameters for each region":
> 
> http://wireless.kernel.org/en/developers/DFS
> 
> In tomorrow's meeting we can cover who is going to work on part III. People who
> want to work on part III can start using these patches on their systems.
> 
> John, lets wait to merge these until Wednesday, I post these in patch form as I
> think they are ready but tomorrow's discussions may push us to alter this a
> bit, not sure. I will also review what we have done here with Michael Green so
> he is on the same page.

Well, now there has been plenty of time to reflect...comments? :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
