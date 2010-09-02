Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54645 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0IBJgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 05:36:32 -0400
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100831150021.GA10963@redhat.com>
References: <20100831150021.GA10963@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 11:36:17 +0200
Message-ID: <1283420177.3793.97.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-31 at 17:00 +0200, Stanislaw Gruszka wrote:

> +	priv->status &= IWL_PRESERVE_STATUS_MASK;

Is that completely save here? No other functions can interfere?

I just ported your patch to the current tree:
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-iwl-scan.patch

but I'm going to split it up into multiple now.

johannes

