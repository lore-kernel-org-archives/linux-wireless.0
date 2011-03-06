Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32745 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab1CFVmr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 16:42:47 -0500
Subject: Re: [ipw3945-devel] can't compile iwlwifi latest wireless-testing
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <AANLkTimaVjAsW4g8kAfi=vQaPCabkj-ZO9vZw_Lex7KY@mail.gmail.com>
References: <AANLkTimaVjAsW4g8kAfi=vQaPCabkj-ZO9vZw_Lex7KY@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Mar 2011 13:26:49 -0800
Message-ID: <1299446809.5082.161.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,


On Fri, 2011-03-04 at 16:15 -0800, Daniel Halperin wrote:
> drivers/net/wireless/iwlwifi/iwl-rx.c: In function
> ‘iwl_rx_card_state_notif’:
> drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: ‘TASK_INTERRUPTIBLE’
> undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: (Each undeclared
> identifier is reported only once
> drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: for each function it
> appears in.)
> 
> 
> iwl-tx.c has an include for sched.h that isn't here and is probably
> the problem.
> 
> 
Stanislow last patch   
commit 466a19a003f3b45a755bc85f967c21da947f9a00: iwlwifi: move rx
handlers code to iwl-rx.c
break the compile

John, please revert the patch

Thanks
Wey



