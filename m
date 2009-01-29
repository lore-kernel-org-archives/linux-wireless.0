Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16723 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbZA2TiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 14:38:23 -0500
Subject: Re: [PATCH] fix led device naming for iwl driver
From: reinette chatre <reinette.chatre@intel.com>
To: Danny Kukawka <dkukawka@suse.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Helmut Schaa <hschaa@suse.de>
In-Reply-To: <200901292029.34976.dkukawka@suse.de>
References: <200901292029.34976.dkukawka@suse.de>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 11:41:21 -0800
Message-Id: <1233258081.2411.65.camel@rc-desk> (sfid-20090129_203827_365809_8050B996)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-01-29 at 11:29 -0800, Danny Kukawka wrote:
> From: Danny Kukawka <dkukawka@suse.de>
> Subject: fix led device naming for iwl driver
>     
> Fixed led device naming for the iwl driver. Due to the
> documentation of the led subsystem/class the naming should be
> "devicename:colour:function" while not applying sections
> should be left blank.
>     
> This should lead to e.g. "iwl-phy0::RX" instead of "iwl-phy0:RX".
> 
> Signed-off-by: Danny Kukawka <dkukawka@suse.de>

Sorry - I missed this in your original submission. The subject does not
identify iwlwifi. Subject could be:

iwlwifi: fix led naming

Looks good otherwise.

Acked-by: Reinette Chatre <reinette.chatre@intel.com>


It may be easier for John if you resubmit with the correct subject - you
can just add my ack when you do.

Thanks

Reinette


