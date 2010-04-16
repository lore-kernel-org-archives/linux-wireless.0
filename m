Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20712 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab0DPRMo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 13:12:44 -0400
Subject: Re: [PATCH] iwlwifi: check scan request ie_len
From: reinette chatre <reinette.chatre@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1271425601-32518-1-git-send-email-sgruszka@redhat.com>
References: <1271425601-32518-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 10:12:43 -0700
Message-ID: <1271437963.14052.13406.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-16 at 06:46 -0700, Stanislaw Gruszka wrote:
> In mac80211 we always check both scan_req->ie and scan_req->ie_len
> against zero before usage, in iwlwifi we should do the same.
> 
> Remove not needed "left -= ie_len" while at it.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

