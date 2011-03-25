Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab1CYPrI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 11:47:08 -0400
Subject: Re: 2.6.38 iwlwifi 11n_disable=1
From: wwguy <wey-yi.w.guy@intel.com>
To: "tim.gardner@canonical.com" <tim.gardner@canonical.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4D8CB794.9040102@canonical.com>
References: <4D8CB794.9040102@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 08:44:34 -0700
Message-ID: <1301067874.9139.7.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tim,

On Fri, 2011-03-25 at 08:41 -0700, Tim Gardner wrote:
> Wey-Yi,
> 
> The Ubuntu Maverick release (2.6.35) has been carrying a user space 
> patch in module-init-tools that disables 802.11n support by default 
> using the 11n_disable module parameter. With the split in 2.6.38 into 
> iwl3945 and iwlagn is it possible that we could now remove the module 
> option for iwlagn? Will the 4965 adapters function correctly with 802.11n?
> 

with both the driver split and new 5000 uCode available at
(http://www.intellinuxwireless.org/?n=Downloads)

I believe we are in very good shape to have 11n support for both legacy
and agn devices. (yes 4965 will have 11n support)

Please remove the module option to disable 11n support.

Thank you very much for the help.

Wey


