Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44840 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZCQOPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 10:15:35 -0400
Date: Tue, 17 Mar 2009 10:13:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org, Luis.Rodriguez@Atheros.com
Subject: Re: Missing commits in wireless-testing
Message-ID: <20090317141308.GD3549@tuxdriver.com> (sfid-20090317_151538_301527_51D30077)
References: <18879.15297.344575.231076@gargle.gargle.HOWL> <20090317130228.GA3549@tuxdriver.com> <18879.42683.919616.530584@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <18879.42683.919616.530584@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 17, 2009 at 07:03:47PM +0530, Sujith wrote:
> John W. Linville wrote:
> > I just went through a (very painful) pseudo-rebase to 2.6.29-rc8
> > last night.  I'm fairly confident that what is there now matches what
> > was there before.
> > 
> > What commit do you think is missing?  What is it's subject line?
> 
> The serialization patches from Luis:
> 
> ath9k: implement IO serialization
> ath9k: AR9280 PCI devices must serialize IO as well
> ath9k: remove dummy PCI "retry timeout" fix
> 
> The code changes are present in wireless-testing, but the git SHA1 IDs
> seem to be absent.

Not sure which IDs you are seeking, but they should all still be there.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
