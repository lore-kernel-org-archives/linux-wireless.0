Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18794 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab0CARqz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 12:46:55 -0500
Subject: Re: iwl4965: 11a channels disabled in current wireless-testing
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <201002281534.11656.helmut.schaa@googlemail.com>
References: <201002281534.11656.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 09:46:55 -0800
Message-ID: <1267465615.2253.159.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-02-28 at 06:34 -0800, Helmut Schaa wrote:
> have there been any recent changes to the regulatory stuff, especially
> in conjunction with iwlagn?
> 
> Because with wireless-testing I get all 11a channels disabled by default
> and the same for channels 12 & 13 in the g-band.

This could be related to a change in the default regulatory domain. It
used to be US, but now it is world, which is more restrictive. You can
modify your regulatory domain using "iw reg set <domain>"

Reinette


