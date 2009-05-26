Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:26481 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728AbZEZQyF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 12:54:05 -0400
Subject: Re: [PATCH] iwlwifi: avoid build warning in iwl-core.
From: reinette chatre <reinette.chatre@intel.com>
To: Rami Rosen <ramirose@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <eb3ff54b0905241043i2c8a0407yeac7d2c07d1e7e1f@mail.gmail.com>
References: <eb3ff54b0905241043i2c8a0407yeac7d2c07d1e7e1f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 May 2009 10:00:45 -0700
Message-Id: <1243357245.7624.3005.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-05-24 at 10:43 -0700, Rami Rosen wrote:
> When building when CONFIG_IWLWIFI_DEBUG is not set is not set, we get
> the following
> warning:
> /work/src/w/drivers/net/wireless/iwlwifi/iwl-core.c: In function ‘iwl_isr’:
> /work/src/w/drivers/net/wireless/iwlwifi/iwl-core.c:1707: warning:
> unused variable ‘inta_fh’
> 
> This patch avoids this warning by adding #ifdef CONFIG_IWLWIFI_DEBUG
> before the declaration of inta_fh in iwl_isr() in
> drivers/net/wireless/iwlwifi/iwl-core.c
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>
> 
> ---

There is just a double "is not set" in the commit message.

Thank you

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


