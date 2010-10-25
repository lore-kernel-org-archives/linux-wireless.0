Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5050 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab0JYOsq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 10:48:46 -0400
Subject: Re: [PATCH 6/7] iwlwifi: defer update power mode while scan
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287759870-5758-6-git-send-email-sgruszka@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
	 <1287759870-5758-6-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Mon, 25 Oct 2010 07:47:56 -0700
Message-Id: <1288018076.3435.12.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-22 at 08:04 -0700, Stanislaw Gruszka wrote:
> Do not set power mode when scanning, and defer that when scan finish.
> We still set power mode in force case i.e. when device is overheated.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---


