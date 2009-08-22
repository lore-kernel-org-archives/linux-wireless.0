Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2449 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbZHVNsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 09:48:13 -0400
Date: Sat, 22 Aug 2009 09:47:41 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: mickflemm@gmail.com, linux-wireless@vger.kernel.org
Subject: 2.6.31 patch for regression #13948
Message-ID: <20090822134741.GD6762@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Can you queue this patch for 2.6.31?  It's on the regression list
but isn't upstream.  I cherry-picked it here and it applied and
built cleanly.

http://bugzilla.kernel.org/show_bug.cgi?id=13948

commit 399b1ffc45081a0f087fe3824b263fd27909cb7a
Author: Nick Kossifidis <mick@madwifi-project.org>
Date:   Mon Aug 10 03:29:02 2009 +0300

    ath5k: Wakeup fixes
    
    * Don't put chip to full sleep because there are problems during
       wakeup. Instead hold MAC/Baseband on warm reset state via a new
       function ath5k_hw_on_hold.
    
     * Minor cleanups
    
    Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
    Tested-by: Ben Greear <greearb@candelatech.com>
    Tested-by: Johannes Stezenbach <js@sig21.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
Bob Copeland %% www.bobcopeland.com

