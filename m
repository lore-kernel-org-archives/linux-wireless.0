Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33977 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbcDMIie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 04:38:34 -0400
Message-ID: <1460536706.3057.3.camel@sipsolutions.net> (sfid-20160413_103851_168980_A309243F)
Subject: Re: [PATCH v3] prism54: isl_38xx: Replace 'struct timeval'
From: Johannes Berg <johannes@sipsolutions.net>
To: Tina Ruchandani <ruchandani.tina@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 13 Apr 2016 10:38:26 +0200
In-Reply-To: <20160413060916.GA21184@localhost> (sfid-20160413_102532_303214_ACA2EBA3)
References: <20160413060916.GA21184@localhost>
	 (sfid-20160413_102532_303214_ACA2EBA3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The patch was build-tested / debugged by removing the
> "if VERBOSE > SHOW_ERROR_MESSAGES" guards.

Stands to reason that we should just remove the (more or less) dead
code, since I don't think anyone really ever touches this driver any
more or will ever again ...

johannes
