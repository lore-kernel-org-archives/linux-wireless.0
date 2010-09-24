Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36184 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107Ab0IXUOf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 16:14:35 -0400
Date: Fri, 24 Sep 2010 16:05:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rebased version of wireless-testing?
Message-ID: <20100924200532.GH8077@tuxdriver.com>
References: <4C9CFD86.2080207@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C9CFD86.2080207@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 24, 2010 at 12:35:34PM -0700, Ben Greear wrote:
> Is there a rebased version of wireless-testing, or is there a way to
> tell git to not apply any patch that was later reverted when pulling?
> 
> I'd like to pull wireless-testing changes into a tree based on linux-2.6,
> but I want it clean enough to easily see what changes I actually
> pulled in.
> 
> If not, I can manually pull in some patches as needed.

Don't do that -- wireless-testing is and likely always will be a mess.
It really only exists as a "-next lite" for those that only want
bleeding-edge wireless while keeping-up with linux-2.6 release
candidates.

You will be better-off pulling wireless-next-2.6 (and maybe
wireless-2.6 as well).  The history there isn't always immutable
(although I prefer it to be), but it will tend to be a lot cleaner
than wireless-testing.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
