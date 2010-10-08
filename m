Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3914 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab0JHSYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 14:24:02 -0400
Date: Fri, 8 Oct 2010 14:25:47 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath5k: Adjust opmode when interfaces are removed.
Message-ID: <20101008182547.GA27479@hash.localnet>
References: <1286556210-29643-1-git-send-email-greearb@candelatech.com> <1286556210-29643-2-git-send-email-greearb@candelatech.com> <AANLkTinXFLL25-r-LUb5vqjNkwoa68xWhN_CaD0KVE=p@mail.gmail.com> <4CAF5DB3.7070603@candelatech.com> <AANLkTi=abVBncBxEKV4oQNSSm4fS5a-qZ=a38BJRPSg_@mail.gmail.com> <4CAF607A.4090305@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CAF607A.4090305@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 08, 2010 at 11:18:34AM -0700, Ben Greear wrote:
> I can just always set the opmode if you prefer that.  Maybe
> change the name of that method.
>
> I'll work on a patch.

Yeah I think that would be better from a long-term maintenance standpoint.
Thanks!

-- 
Bob Copeland %% www.bobcopeland.com

