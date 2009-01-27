Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbZA0Qse (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 11:48:34 -0500
Subject: Re: [PATCH ] iwlwifi: fix iwlwifi warning (pci_enable_device).
From: reinette chatre <reinette.chatre@intel.com>
To: Rami Rosen <roszenrami@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <b25312890901270200h24037f31jaf83f62acb031d1d@mail.gmail.com>
References: <b25312890901270200h24037f31jaf83f62acb031d1d@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 08:51:24 -0800
Message-Id: <1233075084.8772.3.camel@rc-desk> (sfid-20090127_174837_903063_0D8CA0D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-01-27 at 02:00 -0800, Rami Rosen wrote:
> This patch fixes build warnings which are caused as a result
> of iwl-agn.c and iwl3945-base.c resume methods.
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>
> 
> --
> (wireless-testing)

We actually have a fix queued for this and would prefer to use it
instead because it returns the error from pci_enable_device() instead of
a generic "ENODEV".

Reinette


