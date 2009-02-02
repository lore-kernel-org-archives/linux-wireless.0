Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45539 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbZBBS4I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 13:56:08 -0500
Subject: Re: [PATCH 3/4] iwlwifi: another led naming fix
From: reinette chatre <reinette.chatre@intel.com>
To: Danny Kukawka <dkukawka@suse.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Helmut Schaa <hschaa@suse.de>
In-Reply-To: <200901311552.41484.dkukawka@suse.de>
References: <200901311552.41484.dkukawka@suse.de>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 10:59:21 -0800
Message-Id: <1233601161.2411.163.camel@rc-desk> (sfid-20090202_195616_667593_B9C472E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-01-31 at 06:52 -0800, Danny Kukawka wrote:
> From: Danny Kukawka <dkukawka@suse.de>
> Subject: iwlwifi: another led naming fix
> 
> Fixed led device naming for the iwlwifi (iwl-3945) driver. Due 
> to the documentation of the led subsystem/class the naming should 
> be "devicename:colour:function" while not applying sections
> should be left blank.
>     
> This should lead to e.g. "iwl-%s::RX" instead of "iwl-%s:RX".
> 
> Signed-off-by: Danny Kukawka <dkukawka@suse.de>

Thank you

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette



