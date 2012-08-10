Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40061 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab2HJRTd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 13:19:33 -0400
Message-ID: <5025429E.8020208@hauke-m.de> (sfid-20120810_191936_321427_04486008)
Date: Fri, 10 Aug 2012 19:19:26 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Andy Gospodarek <andy@greyhouse.net>
CC: mcgrof@frijolero.org,
	lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Phil Perry <phil@elrepo.org>
Subject: Re: [PATCH v2] compat: support RHEL6.3 as a build target
References: <1344487215-24143-1-git-send-email-andy@greyhouse.net>
In-Reply-To: <1344487215-24143-1-git-send-email-andy@greyhouse.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2012 06:40 AM, Andy Gospodarek wrote:
> This patch allows me to compile and load the latest compat modules on
> RHEL6.3.  Users of compat on RHEL6 should note that you should set
> CONFIG_COMPAT_KFIFO=n as those bits are not needed at all.
> 
To disable CONFIG_COMPAT_KFIFO you should prepare a patch for
compat-wireless and make use of CONFIG_COMPAT_RHEL_6_3.

Hauke

