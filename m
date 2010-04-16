Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52756 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757610Ab0DPSEv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 14:04:51 -0400
Subject: Re: [PATCH] iwlwifi: initialize iwl_wimax_coex_cmd.flags
From: reinette chatre <reinette.chatre@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1271425676-32552-1-git-send-email-sgruszka@redhat.com>
References: <1271425676-32552-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 11:04:50 -0700
Message-ID: <1271441090.14052.13515.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-16 at 06:47 -0700, Stanislaw Gruszka wrote:
> iwl_wimax_coex_cmd.flags can be really uninitialized, so fix
> that.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---

Thank you

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


