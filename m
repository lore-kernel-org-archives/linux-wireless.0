Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15320 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052Ab0KLPyl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 10:54:41 -0500
Subject: Re: [PATCH 3/3] iwlwifi: kill elapsed_jiffies
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1289548027-3383-3-git-send-email-sgruszka@redhat.com>
References: <1289548027-3383-1-git-send-email-sgruszka@redhat.com>
	 <1289548027-3383-3-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Fri, 12 Nov 2010 07:53:50 -0800
Message-Id: <1289577230.16178.8.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-11 at 23:47 -0800, Stanislaw Gruszka wrote:
> Subtract of jiffies is fine even if one variable overwrap.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>


