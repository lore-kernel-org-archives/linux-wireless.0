Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab1HOOXF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 10:23:05 -0400
Date: Mon, 15 Aug 2011 16:21:45 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 05/60] iwlagn: introduce struct iwl-shared - known by all
 layers
Message-ID: <20110815142144.GA15718@redhat.com> (sfid-20110815_162309_761267_970A3F4D)
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
 <1313257116-2697-6-git-send-email-wey-yi.w.guy@intel.com>
 <20110815081010.GA3317@redhat.com>
 <20110815084355.GB3317@redhat.com>
 <1313414020.15170.32.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1313414020.15170.32.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 15, 2011 at 06:13:39AM -0700, Guy, Wey-Yi wrote:
> now we are working on separate iwlagn driver into two layers (upper and
> lower), the lower layer contains both bus and transport sub-layer which
> is hw dependent, and the upper layer should be bus/hw independent. by
> doing so, the single driver can handle different bus and different core
> architecture. Having the share data structure (priv->shrd->foo) between
> two layers is for that reason (loosely couple).

You did not explained reason for introducing iwl_shared structure,
actually you confirmed it is useless. You should simply share iwl_priv
on any layer you have.

Stanislaw
