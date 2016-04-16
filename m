Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:54138 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbcDPXej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 19:34:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tina Ruchandani <ruchandani.tina@gmail.com>,
	y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] prism54: isl_38xx: Replace 'struct timeval'
Date: Sun, 17 Apr 2016 01:34:33 +0200
Message-ID: <5521267.mr5HLCdTY6@wuerfel> (sfid-20160417_013500_418669_50AE4528)
In-Reply-To: <1460536706.3057.3.camel@sipsolutions.net>
References: <20160413060916.GA21184@localhost> <1460536706.3057.3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 13 April 2016 10:38:26 Johannes Berg wrote:
> > The patch was build-tested / debugged by removing the
> > "if VERBOSE > SHOW_ERROR_MESSAGES" guards.
> 
> Stands to reason that we should just remove the (more or less) dead
> code, since I don't think anyone really ever touches this driver any
> more or will ever again ...

Do you mean removing all DEBUG() statements from the driver, or
removing the entire driver?

	Arnd
