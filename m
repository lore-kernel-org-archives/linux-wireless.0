Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53363 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbZGGRPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 13:15:54 -0400
Date: Tue, 7 Jul 2009 13:03:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: javier@cozybit.com
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	johannes@sipsolutions.net, Andrey Yurovsky <andrey@cozybit.com>
Subject: Re: [PATCH v3] Fix regression in mesh forwarding path.
Message-ID: <20090707170307.GC2768@tuxdriver.com>
References: <1246929954-15282-1-git-send-email-javier@cozybit.com> <1246935252-19823-1-git-send-email-javier@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1246935252-19823-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 06, 2009 at 07:54:12PM -0700, javier@cozybit.com wrote:
> From: Javier Cardona <javier@cozybit.com>
> 
> The removal of the master netdev broke the mesh forwarding path.  This patch
> fixes it by using the new internal 'pending' queue.
> 
> As a result of this change, mesh forwarding no longer does the inefficient
> 802.11 -> 802.3 -> 802.11 conversion that was done before.

I'm sorry, but this doesn't seem to apply on top of the current tree.
Would you mind taking a look and respinning?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
