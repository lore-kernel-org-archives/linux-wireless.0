Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62193 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab0HRQq6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:46:58 -0400
Subject: Re: [PATCH 1/2] iwlagn: do not check for AP mode for WEP keys
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1282149604.5249.5.camel@jlt3.sipsolutions.net>
References: <1282149322-17928-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1282149322-17928-2-git-send-email-wey-yi.w.guy@intel.com>
	 <1282149604.5249.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 09:51:21 -0700
Message-ID: <1282150281.4235.1.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-18 at 09:40 -0700, Johannes Berg wrote:
> On Wed, 2010-08-18 at 09:35 -0700, Wey-Yi Guy wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Even when we configure WEP keys in AP mode
> > ones without a station pointer are default
> > keys, so don't check for AP mode here.
> 
> I don't think this needs to go into 2.6.35 (or 2.6.36, which I think you
> meant?) since we don't support AP mode.
> 
so 2.6.37?

Wey


