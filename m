Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17650 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZGaFqw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 01:46:52 -0400
Subject: Re: [PATCH] iwlwifi: remove usage of orig_flags
From: reinette chatre <reinette.chatre@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1249004247-20780-1-git-send-email-lrodriguez@atheros.com>
References: <1249004247-20780-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 22:46:52 -0700
Message-Id: <1249019212.30019.78.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-30 at 18:37 -0700, Luis R. Rodriguez wrote:
> This is a private flag, internal to cfg80211. cfg80211
> will set orig_* stuff internally upon wiphy registration,
> drivers do not need to muck with it.
> 
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you

Reinette


