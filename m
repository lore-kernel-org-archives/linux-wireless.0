Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41021 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbZCQNPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 09:15:35 -0400
Date: Tue, 17 Mar 2009 09:02:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org, Luis.Rodriguez@Atheros.com
Subject: Re: Missing commits in wireless-testing
Message-ID: <20090317130228.GA3549@tuxdriver.com> (sfid-20090317_141539_224317_A59BFF15)
References: <18879.15297.344575.231076@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <18879.15297.344575.231076@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 17, 2009 at 11:27:21AM +0530, Sujith wrote:

> Luis' serialization patches have been merged in wireless-testing,
> but the commit IDs are missing. I did a git pull today and
> git-describe shows: v2.6.29-rc8-18593-gef1cb6f
> 
> No compilation breakage, though.

I just went through a (very painful) pseudo-rebase to 2.6.29-rc8
last night.  I'm fairly confident that what is there now matches what
was there before.

What commit do you think is missing?  What is it's subject line?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
