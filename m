Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45211 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3CKTPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 15:15:30 -0400
Date: Mon, 11 Mar 2013 15:05:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Allow over-riding reg-domain.
Message-ID: <20130311190537.GB32171@tuxdriver.com> (sfid-20130311_201540_415821_6AF76030)
References: <1363020306-924-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363020306-924-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 11, 2013 at 09:45:06AM -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Otherwise, can't get the Sparklan AR9380 NICs to be
> 5Ghz APs, since they are in world-roaming domain by
> default.  Add this to /etc/modprobe.d/ath9k.conf:
> 
> options ath9k override_eeprom_regdomain=0
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Why "=0" to enable it?  Just to make it more confusing?

Do the Atheros folks have an opinion on this?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
