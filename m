Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34148 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab0JUO1F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 10:27:05 -0400
Subject: Re: [PATCH 1/2] iwlwifi: fix set_tx_power vs scan
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101021131348.GA5654@redhat.com>
References: <1286977193-12144-1-git-send-email-sgruszka@redhat.com>
	 <1286983100.10446.1.camel@wwguy-ubuntu> <20101014083204.GA2286@redhat.com>
	 <20101021131348.GA5654@redhat.com>
Content-Type: text/plain
Date: Thu, 21 Oct 2010 07:26:14 -0700
Message-Id: <1287671174.25126.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-21 at 06:13 -0700, Stanislaw Gruszka wrote:
> On Thu, Oct 14, 2010 at 10:32:05AM +0200, Stanislaw Gruszka wrote:
> > > Looks good, the only thing is if priv->tx_power_user_lmt ==
> > > priv->tx_power_next, we don't even have to call set_tx_power, but I
> > > guess calling it won't hurt, so its your decision check or not.
> > 
> > I'll will call iwl_set_tx_power( ... , false); what seems to be right
> > thing to do.
> 
> Set tx power have to be forces. Without that I get  
> 
Thanks

Wey

