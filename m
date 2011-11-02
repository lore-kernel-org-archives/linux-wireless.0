Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1KBHwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 03:52:38 -0400
Subject: Re: problem clearing bit-rates with 'iw'
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4EAF228F.6030104@candelatech.com> (sfid-20111031_233459_465667_F36C4610)
References: <4EAF228F.6030104@candelatech.com>
	 (sfid-20111031_233459_465667_F36C4610)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 08:52:29 +0100
Message-ID: <1320220349.3950.0.camel@jlt3.sipsolutions.net> (sfid-20111102_085241_186673_C5F29BBC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-31 at 15:34 -0700, Ben Greear wrote:
> According to the help, it seems I should be able to pass no rates and
> have it clear the mask.  But, it seems that is not actually working:
> 
> [root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw dev sta4 set bitrates legacy-2.4
> command failed: Invalid argument (-22)

remove the "legacy-2.4" thing.

johannes

