Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab0IFHgc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 03:36:32 -0400
Date: Mon, 6 Sep 2010 09:32:58 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 04/13] iwlwifi: cancel scan when down the device
Message-ID: <20100906073255.GB3024@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
 <1283515056-11523-5-git-send-email-sgruszka@redhat.com>
 <1283524697.5211.15.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283524697.5211.15.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Fri, Sep 03, 2010 at 07:38:17AM -0700, Guy, Wey-Yi wrote:
> > -		mutex_lock(&priv->mutex);
> > -		iwl_scan_cancel_timeout(priv, 100);
> > -		mutex_unlock(&priv->mutex);
> > -	}
> > -
> >  	iwl_down(priv);
> 
> I see you remove the "mutex" here, not needed?

Yes, is needed, this is fixed in patch 8.

Stanislaw
