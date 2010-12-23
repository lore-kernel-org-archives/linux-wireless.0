Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23887 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab0LWQLM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 11:11:12 -0500
Subject: Re: [PATCH v2] iwlagn: fix scan tx antenna setting on 5Ghz band
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1293113550-10977-1-git-send-email-sgruszka@redhat.com>
References: <1293113550-10977-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 08:02:18 -0800
Message-ID: <1293120138.3997.49.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-23 at 06:12 -0800, Stanislaw Gruszka wrote:
> Looks that we do not set correctly antennas when scanning
> on 5Ghz band and when bluetooth is enabled, because
> priv->cfg->scan_tx_antennas[band] is only defined for
> IEEE80211_BAND_2GHZ.
> 
> To fix we check band before limiting antennas to first one.
> This allow to remove hard coded cfg->scan_tx_antennas[band].
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>


Thanks
Wey

