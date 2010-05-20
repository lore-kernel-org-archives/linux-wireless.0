Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab0ETQ0M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 12:26:12 -0400
Subject: Re: [PATCH 07/11] drivers/net/wireless: Storage class should be
 before const qualifier
From: reinette chatre <reinette.chatre@intel.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"luciano.coelho@nokia.com" <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <1274344691-9095-1-git-send-email-tklauser@distanz.ch>
References: <1274344691-9095-1-git-send-email-tklauser@distanz.ch>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 09:26:10 -0700
Message-ID: <1274372770.2091.9098.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-20 at 01:38 -0700, Tobias Klauser wrote:
> The C99 specification states in section 6.11.5:
> 
> The placement of a storage-class specifier other than at the beginning
> of the declaration specifiers in a declaration is an obsolescent
> feature.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---

For the iwlwifi parts ...

Thank you

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


