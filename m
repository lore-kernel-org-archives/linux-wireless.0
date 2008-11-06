Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbYKFRHE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 12:07:04 -0500
Subject: Re: iwlagn: wrong command queue 31, command id 0x0
From: reinette chatre <reinette.chatre@intel.com>
To: Matt Mackall <mpm@selenic.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1225944979.3792.3.camel@calx>
References: <1225944979.3792.3.camel@calx>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 09:07:35 -0800
Message-Id: <1225991255.1115.657.camel@rc-desk> (sfid-20081106_180708_395617_B7E5D08A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-05 at 20:16 -0800, Matt Mackall wrote:
> As of 75fa67706cce5272bcfc51ed646f2da21f3bdb6e, I'm seeing this:
> 
> [ 5470.869820] WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204
> iwl_rx_handle+0x11a/0x21b [iwlagn]()
> [ 5470.869824] wrong command queue 31, command id 0x0

This is a known issue that is being tracked at
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703

Reinette

