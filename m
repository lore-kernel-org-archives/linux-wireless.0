Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([204.152.186.63]:60836 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbXCNRoO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2007 13:44:14 -0400
Date: Wed, 14 Mar 2007 17:17:42 +0000
From: Jouni Malinen <j@w1.fi>
To: Kyle McMartin <kyle@canonical.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	hostap@shmoo.com, j@w1.fi
Subject: Re: [HOSTAP] Make debug a run-time option
Message-ID: <20070314171742.GA20779@hostap.isc.org>
References: <20070314160356.GA16337@athena.road.mcmartin.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070314160356.GA16337@athena.road.mcmartin.ca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 14, 2007 at 12:03:56PM -0400, Kyle McMartin wrote:
> Build-time debugging isn't overly useful for distro kernel folks, nor is
> enabling huge amounts of debug spew by default. Provide the option of
> enabling debugging with module parameters.

While I understand that it would be difficult to change the debug level
options with binary distributions, I'm not sure whether I would like to
see these changes going in. PRISM2_NO_DEBUG was added to make it
possible to reduce the driver size considerably. In addition, the change
to the default debug categories (i.e., disable all) may make it more
difficult to understand reported issues. I would be more open to
disabling debug messages one-by-one if there is something specific that
can be agreed to cause more harm than benefit with extra output.

-- 
Jouni Malinen                                            PGP id EFC895FA
