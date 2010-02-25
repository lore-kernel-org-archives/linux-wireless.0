Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:40036 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758640Ab0BYAvO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2010 19:51:14 -0500
Subject: Re: ipw2100 crash with latest git
From: Zhu Yi <yi.zhu@intel.com>
To: legolas558 <legolas558@users.sourceforge.net>
Cc: "ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4B859BB3.60001@users.sourceforge.net>
References: <4B859BB3.60001@users.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 08:52:33 +0800
Message-ID: <1267059153.16986.1513.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-02-25 at 05:35 +0800, Daniele C. wrote:
> - --->8-----
> Feb 24 21:53:20 fester kernel: ipw2100: exit - failed to send
> CARD_DISABLE command
> Feb 24 21:53:20 fester kernel: ipw2100: exit - failed to send
> CARD_DISABLE command
> Feb 24 21:54:16 fester kernel: ipw2100: Fatal interrupt. Scheduling
> firmware restart.
> Feb 24 21:56:47 fester kernel: ipw2100: exit - failed to send
> CARD_DISABLE command
> Feb 24 21:58:51 fester kernel: ipw2100: exit - failed to send
> CARD_DISABLE command
> Feb 24 22:07:11 fester kernel: ipw2100: exit - failed to send
> CARD_DISABLE command
> Feb 24 22:09:57 fester kernel: ipw2100: Fatal interrupt. Scheduling
> firmware restart.
> Feb 24 22:11:09 fester acpid: client 3208[0:100] has disconnected
> Feb 24 22:11:09 fester acpid: client connected from 3208[0:100]
> Feb 24 22:11:09 fester acpid: 1 client rule loaded
> Feb 24 22:28:49 fester kernel: ipw2100: Fatal interrupt. Scheduling
> firmware restart.
> - --->8-----

This is a firmware error. Does the driver recover itself later?

Thanks,
-yi

