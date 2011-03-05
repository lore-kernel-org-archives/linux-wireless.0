Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35330 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1CEARr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 19:17:47 -0500
Received: by iwn34 with SMTP id 34so2370138iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 16:17:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimaVjAsW4g8kAfi=vQaPCabkj-ZO9vZw_Lex7KY@mail.gmail.com>
References: <AANLkTimaVjAsW4g8kAfi=vQaPCabkj-ZO9vZw_Lex7KY@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Fri, 4 Mar 2011 16:17:27 -0800
Message-ID: <AANLkTinZ=t7WHVGh+BpSc6LzyOtKGWAQ86vGpJwx2=ML@mail.gmail.com>
Subject: Fwd: can't compile iwlwifi latest wireless-testing
To: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I need to remember not to send HTML mails.  Sorry.

Dan

---------- Forwarded message ----------
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Fri, Mar 4, 2011 at 4:15 PM
Subject: can't compile iwlwifi latest wireless-testing
To: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net


drivers/net/wireless/iwlwifi/iwl-rx.c: In function ‘iwl_rx_card_state_notif’:
drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: ‘TASK_INTERRUPTIBLE’
undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: (Each undeclared
identifier is reported only once
drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: for each function it
appears in.)
iwl-tx.c has an include for sched.h that isn't here and is probably the problem.
Dan
