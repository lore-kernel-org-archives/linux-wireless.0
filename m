Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40987 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab1AYVpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 16:45:09 -0500
Date: Tue, 25 Jan 2011 16:37:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH RESEND 09/11] ath9k: Try all queues when looking for next
 packet to send.
Message-ID: <20110125213710.GD2927@tuxdriver.com>
References: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
 <1294643513-18820-10-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1294643513-18820-10-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 09, 2011 at 11:11:51PM -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> There can be multiple struct ath_atx_ac entries for each
> txq, so if the first one doesn't have any packets to send
> now, try the rest of them.  This should help keep xmit
> going when using multiple stations, especially with AMPDU
> enabled.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>

This one doesn't seem to apply any more.  Can I persuade you to rebase
and resubmit it?

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
