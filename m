Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50475 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758339Ab1CCPfC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 10:35:02 -0500
Subject: Re: [PATCH v3 5/5] iwlwifi: move remaining iwl-agn-rx.c code into
 iwl-rx.c
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110303091918.GA2190@redhat.com>
References: <1298899997-2372-1-git-send-email-sgruszka@redhat.com>
	 <1298899997-2372-5-git-send-email-sgruszka@redhat.com>
	 <1299096009.5082.127.camel@wwguy-huron>  <20110303091918.GA2190@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 07:19:33 -0800
Message-ID: <1299165573.5082.128.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Thu, 2011-03-03 at 01:19 -0800, Stanislaw Gruszka wrote:
> Hello
> 
> On Wed, Mar 02, 2011 at 12:00:09PM -0800, Guy, Wey-Yi wrote:
> > I got the following warning:
> > 
> > drivers/net/wireless/iwlwifi/iwl-rx.c:506:6: warning: symbol
> > 'iwl_rx_statistics' was not declared. Should it be static?
> > drivers/net/wireless/iwlwifi/iwl-rx.c:575:6: warning: symbol
> > 'iwl_reply_statistics' was not declared. Should it be static?
> > drivers/net/wireless/iwlwifi/iwl-rx.c:600:6: warning: symbol
> > 'iwl_rx_missed_beacon_notif' was not declared. Should it be static?
> 
> include "iwl-agh.h" should make warning go away, but perhaps
> would be better to move all rx_handlers to iwl-rx.c, make them
> statics and export only iwl_setup_rx_handlers ?
> 
I like the 2nd approach and make it "static", could you like to do it,
or I can make the changes.

Thanks
Wey


