Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab1FVU07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 16:26:59 -0400
Subject: Re: [3.0 regression] DMAR faults in iwlagn
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lutomirski <luto@mit.edu>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1308774283.29571.24.camel@jlt3.sipsolutions.net> (sfid-20110622_222449_263549_431D3C5E)
References: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com>
	 (sfid-20110620_204449_827132_DD43A304)  <1308774283.29571.24.camel@jlt3.sipsolutions.net>
	 (sfid-20110622_222449_263549_431D3C5E)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 22:26:56 +0200
Message-ID: <1308774416.29571.26.camel@jlt3.sipsolutions.net> (sfid-20110622_222702_017253_588A50D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-22 at 22:24 +0200, Johannes Berg wrote:
> Andy, could you try this patch?
> 
> I haven't tested it at all yet, it's kinda late here.

Oh, it also requires this patch first:

http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=commitdiff;h=3d007d90374fe263d9e7982d04217cdcbaceb54c

johannes

