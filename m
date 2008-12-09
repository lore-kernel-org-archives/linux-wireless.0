Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21861 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYLIGmu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 01:42:50 -0500
Subject: Re: [PATCH ] iwlwifi: fix build error (iwl-rx.c).
From: reinette chatre <reinette.chatre@intel.com>
To: Rami Rosen <ramirose@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"m.sujith@gmail.com" <m.sujith@gmail.com>
In-Reply-To: <eb3ff54b0812082237v35bdd49jbce0ad59c218bc26@mail.gmail.com>
References: <eb3ff54b0812082237v35bdd49jbce0ad59c218bc26@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 22:43:51 -0800
Message-Id: <1228805031.30670.11.camel@rc-desk> (sfid-20081209_074253_876327_BBD04494)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-08 at 22:37 -0800, Rami Rosen wrote:
> This patch adds #ifdef CONFIG_IWLWIFI_DEBUG in iwl_rx_reply_rx() method
> in iwlwifi/iwl-rx.c) to avoid build error.
> ,caused by commit c778f6d6b339bb4981d5d2dd8716286f756b8474.
> 
> (wireless-testing tree.)
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

This fix works also. 

Thank you very much

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


