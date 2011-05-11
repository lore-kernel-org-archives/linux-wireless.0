Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50248 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab1EKDbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 23:31:32 -0400
Subject: Re: GIT net-2.6 rolled back 8 commits...
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	netfilter-devel@vger.kernel.org
In-Reply-To: <20110510.150814.226778453.davem@davemloft.net>
References: <20110510.150814.226778453.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 05:31:27 +0200
Message-ID: <1305084687.2437.44.camel@edumazet-laptop> (sfid-20110511_053136_795901_9E0484A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le mardi 10 mai 2011 à 15:08 -0700, David Miller a écrit :
> I made a mistake and applied to net-2.6 a patch from Eric Dumazet that
> only is applicable for net-next-2.6
> 
> I really don't want to have to toss Linus that commit and a revert commit
> just to fix it up.
> 
> So I rewound the net-2.6 tree by 8 commits.
> 
> So if you've pulled in the past 3 hours, please reset your pull and repull.
> 

Thanks David

Would it be possible you sync net-next-2.6 and pull net-2.6 in it ?

Eric


