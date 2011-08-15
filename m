Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1HOIpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 04:45:09 -0400
Date: Mon, 15 Aug 2011 10:43:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 05/60] iwlagn: introduce struct iwl-shared - known by all
 layers
Message-ID: <20110815084355.GB3317@redhat.com> (sfid-20110815_104512_263478_F96B07D3)
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
 <1313257116-2697-6-git-send-email-wey-yi.w.guy@intel.com>
 <20110815081010.GA3317@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110815081010.GA3317@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 15, 2011 at 10:10:11AM +0200, Stanislaw Gruszka wrote:
> What for are you doing this? These changes through patch 60 seems
> have no sense.
I mean only these containing priv->foo to priv->shrd->foo transaction.

Stanislaw
