Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52718 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1HXUaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 16:30:12 -0400
Date: Wed, 24 Aug 2011 16:25:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: refactor skb copy to failq in
 mesh_path_move_to_queue
Message-ID: <20110824202556.GM9770@tuxdriver.com> (sfid-20110824_223015_800320_C00F28F1)
References: <1314213161-8871-1-git-send-email-linville@tuxdriver.com>
 <CAG6hwVNvLREnnZQ0t8UaKZ7Q1nn-4kx=z_1nPzVG89a5NMWFpg@mail.gmail.com>
 <20110824193224.GL9770@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110824193224.GL9770@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 03:32:24PM -0400, John W. Linville wrote:
> On Wed, Aug 24, 2011 at 12:27:29PM -0700, Thomas Pedersen wrote:

> > However, this does look nicer. Please be sure to apply the version
> > submitted on 11 August.
> 
> You just told me yesterday to apply the 9 August version???

In any case, that is what I applied.  Please review it and submit
fixup patches for anything that needs to be different.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
