Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45551 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597AbZGNVyc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 17:54:32 -0400
Subject: Re: [PATCH] iwlwifi: make some logging functions static/unexport
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247579291.7178.9.camel@johannes.local>
References: <1247579291.7178.9.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 14:54:31 -0700
Message-Id: <1247608471.17896.1938.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-14 at 06:48 -0700, Johannes Berg wrote:
> iwl_dump_nic_error_log can be static and iwl_dump_nic_event_log
> doesn't need to be exported.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you

Reinette


