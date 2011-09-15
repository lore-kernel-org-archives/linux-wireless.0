Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:53173 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932690Ab1IOXOa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 19:14:30 -0400
Subject: Re: [PATCH] iwlagn: Convert kzalloc to kcalloc
From: Joe Perches <joe@perches.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Thu, 15 Sep 2011 16:14:29 -0700
In-Reply-To: <1316127246.7631.2.camel@wwguy-ubuntu>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1316112414-6341-9-git-send-email-wey-yi.w.guy@intel.com>
	 <1316115470.11236.1.camel@Joe-Laptop>
	 <1316112830.19293.4.camel@wwguy-huron>
	 <1316116047.11236.8.camel@Joe-Laptop>
	 <1316127246.7631.2.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1316128469.12897.4.camel@Joe-Laptop> (sfid-20110916_011433_797858_F7B99AA1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 15:54 -0700, wwguy wrote:
> On Thu, 2011-09-15 at 12:47 -0700, Joe Perches wrote:
> > Convert kzalloc to kcalloc, coalesce multiple lines too.
> IIRC, there is no real different between kcalloc and kzalloc, I think
> kcalloc will call kzalloc; both zero out the memory before return.

Multiplication overflow protection.

