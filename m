Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from que21.charter.net ([209.225.8.22]:51658 "EHLO que21.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166Ab1IHD4H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 23:56:07 -0400
Message-ID: <4E683BBE.3060105@cuw.edu> (sfid-20110908_055614_154044_54791BC5)
Date: Wed, 07 Sep 2011 22:51:26 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iwlegacy: change IWL_WARN to IWL_DEBUG_HT in iwl4965_tx_agg_start
References: <1314537977-20097-1-git-send-email-Gregory.Dietsche@cuw.edu> <20110829122013.GA3597@redhat.com> <4E5B9533.6000109@cuw.edu> <20110829140032.GA1573@redhat.com> <20110906150131.GA7322@redhat.com>
In-Reply-To: <20110906150131.GA7322@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,
On 09/06/2011 10:01 AM, Stanislaw Gruszka wrote:
> I put patches here:
> http://people.redhat.com/sgruszka/iwlegacy_cleanup.tar.bz2
>
> They are on top of wireless-testing tree.
>    
<snip>
> Series include your 2 patches. You can test this cleanup and
> apply your new changes on top. I'll not do any further cleanup
> for some time now, perhaps continue when I got public git tree.
>
>    
Thanks! I've re-worked my patches and you can find them here:
http://www.gregd.org/stuff/linux/iwlegacy_cleanup_greg.tar.bz2

I also decided to play with github a little bit: 
git://github.com/dietsche/linux.git and pushed two branches:
   1) wireless-next-iwlegacy-stanislaw - your patch set
   2) wireless-next-iwlegacy-stanislaw-greg - a branch that has my 
additional patches.
`git format-patch 
wireless-next-iwlegacy-stanislaw..wireless-next-iwlegacy-stanislaw-greg` 
will generate the patches that are in the link i posted above.

The first two patches in my series are the ones that I think folks 
should take a closer look at. The rest are pretty safe.

I'm running both patch sets right now on my laptop. So far it is running 
perfectly.

Greg

