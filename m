Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37199 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423508AbXEBVRr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 17:17:47 -0400
Received: from griffin.suse.cz (griffin.suse.cz [10.20.1.99])
	by mail.suse.cz (SUSE LINUX ESMTP Mailer) with ESMTP id C323D6280B5
	for <linux-wireless@vger.kernel.org>; Wed,  2 May 2007 23:17:46 +0200 (CEST)
Date: Wed, 2 May 2007 23:17:32 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix false lockdep warning
Message-ID: <20070502231732.72803c77@griffin.suse.cz>
In-Reply-To: <20070502231425.135f87b4@griffin.suse.cz>
References: <20070502231425.135f87b4@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2 May 2007 23:14:25 +0200, Jiri Benc wrote:
> +enum netif_tx_lock_class {
> +	TX_LOCK_NORMAL,
> +	TX_LOCK_MASTER,
> +}

Forgot to refresh the patch before sending. A semicolon is missing here.

 J.

-- 
Jiri Benc
SUSE Labs
