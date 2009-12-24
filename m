Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11393 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZLXAwu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 19:52:50 -0500
Subject: Re: [PATCH] iwlwifi: Storage class should be before const qualifier
From: Zhu Yi <yi.zhu@intel.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1261574291-9384-1-git-send-email-tklauser@distanz.ch>
References: <1261574291-9384-1-git-send-email-tklauser@distanz.ch>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 08:52:48 +0800
Message-ID: <1261615968.12157.854.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-12-23 at 21:18 +0800, Tobias Klauser wrote:
> The C99 specification states in section 6.11.5:
> 
> The placement of a storage-class specifier other than at the beginning
> of the declaration specifiers in a declaration is an obsolescent
> feature.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch> 

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

