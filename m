Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48944 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab1KPHv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 02:51:58 -0500
Subject: Re: Build Error Report
From: Johannes Berg <johannes@sipsolutions.net>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Masahiro Inoue <miyabi.-.inoue@nifty.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1321413070.1796.43.camel@wwguy-ubuntu> (sfid-20111116_041731_230210_0AAA8175)
References: <20111116104133.E58B.2E210E2F@nifty.com>
	 <1321413070.1796.43.camel@wwguy-ubuntu>
	 (sfid-20111116_041731_230210_0AAA8175)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 08:51:51 +0100
Message-ID: <1321429911.4773.9.camel@jlt3.sipsolutions.net> (sfid-20111116_085200_563057_08F68393)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-15 at 19:11 -0800, wwguy wrote:
> hmm, Johannes, I guess we miss this one

> > /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c: In function 'iwlagn_rx_noa_notification':
> > /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c:1075: error: implicit declaration of function 'kfree_rcu'
> > /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c:1075: error: 'rcu_head' undeclared (first use in this function)
> > /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c:1075: error: (Each undeclared identifier is reported only once
> > /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c:1075: error: for each function it appears in.)

No, Luis just never applied my fix to compat upstream :)

johannes

