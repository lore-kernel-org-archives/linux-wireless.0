Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54226 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbbKRVa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 16:30:58 -0500
Date: Wed, 18 Nov 2015 16:30:56 -0500 (EST)
Message-Id: <20151118.163056.1623378839925091670.davem@davemloft.net> (sfid-20151118_223124_518413_726EB64E)
To: egrumbach@gmail.com
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/27] iwlwifi: move under intel vendor directory
From: David Miller <davem@davemloft.net>
In-Reply-To: <CANUX_P0TpjGhvvo3EyPqLr6An4ERrgDCTY-suzsdjZY-e_NgcA@mail.gmail.com>
References: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org>
	<1447857966-19560-11-git-send-email-kvalo@codeaurora.org>
	<CANUX_P0TpjGhvvo3EyPqLr6An4ERrgDCTY-suzsdjZY-e_NgcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Wed, 18 Nov 2015 23:21:31 +0200

> I am sorry but I'd prefer to wait with this. We have a big machinery
> of scripts / builds and alike that will break.

Sorry, that's not a reason to stop this reorganization.
