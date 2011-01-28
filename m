Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23234 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab1A1QPm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:15:42 -0500
Subject: Re: [PATCH 5/8] iwlwifi: remove unneeded disable_hw_scan check
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1296229671-3041-5-git-send-email-sgruszka@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
	 <1296229671-3041-5-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 08:14:08 -0800
Message-ID: <1296231248.7388.14.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw,

On Fri, 2011-01-28 at 07:47 -0800, Stanislaw Gruszka wrote:
> We never set STATUS_SCANNING in softwre scanning mode, disable_hw_scan
> check is unneeded. Correct debug message while at it.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---


