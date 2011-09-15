Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61097 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935256Ab1IOW7V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 18:59:21 -0400
Subject: Re: [PATCH] iwlagn: Convert kzalloc to kcalloc
From: wwguy <wey-yi.w.guy@intel.com>
To: Joe Perches <joe@perches.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
In-Reply-To: <1316116047.11236.8.camel@Joe-Laptop>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1316112414-6341-9-git-send-email-wey-yi.w.guy@intel.com>
	 <1316115470.11236.1.camel@Joe-Laptop>
	 <1316112830.19293.4.camel@wwguy-huron>
	 <1316116047.11236.8.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 15:54:06 -0700
Message-ID: <1316127246.7631.2.camel@wwguy-ubuntu> (sfid-20110916_005924_798225_22CD64A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 12:47 -0700, Joe Perches wrote:
> Convert kzalloc to kcalloc, coalesce multiple lines too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---

IIRC, there is no real different between kcalloc and kzalloc, I think
kcalloc will call kzalloc; both zero out the memory before return.

Wey


