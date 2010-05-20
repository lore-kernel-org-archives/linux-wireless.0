Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25900 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab0ETRF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 13:05:59 -0400
Subject: Re: [PATCH 07/11] drivers/net/wireless: Storage class should be
 before const qualifier
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Tobias Klauser <tklauser@distanz.ch>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"reinette.chatre@intel.com" <reinette.chatre@intel.com>,
	"yi.zhu@intel.com" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <1274344691-9095-1-git-send-email-tklauser@distanz.ch>
References: <1274344691-9095-1-git-send-email-tklauser@distanz.ch>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 20:05:54 +0300
Message-ID: <1274375154.1475.40.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-20 at 10:38 +0200, ext Tobias Klauser wrote:
> The C99 specification states in section 6.11.5:
> 
> The placement of a storage-class specifier other than at the beginning
> of the declaration specifiers in a declaration is an obsolescent
> feature.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---

Thanks! Regarding wl1271:

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>


-- 
Cheers,
Luca.

