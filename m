Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15914 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758029AbZBLShE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 13:37:04 -0500
Subject: Re: [PATCH] iwlagn: clean up error path in iwl_pci_probe
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200902121851.04202.helmut.schaa@gmail.com>
References: <200902121851.04202.helmut.schaa@gmail.com>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 10:40:55 -0800
Message-Id: <1234464055.30608.8.camel@rc-desk> (sfid-20090212_193710_362510_EAF84D71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-02-12 at 09:51 -0800, Helmut Schaa wrote:
> This avoids triggering a BUG_ON in pci_disable_msi in the error path.
> Furthermore remove the first call to pci_disable_device as it is already
> called at out_pci_disable_device.
> 
> Both issues were introduced in the patch "iwlagn: fix hw-rfkill while
> the interface is down".
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---

Thank you.

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

