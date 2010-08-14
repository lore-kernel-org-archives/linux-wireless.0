Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40032 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0HNTmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Aug 2010 15:42:45 -0400
Subject: Re: [PATCH 0/2] iwlwifi fix for 2.6.35
From: Marcel Holtmann <marcel@holtmann.org>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1281800751-20784-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1281800751-20784-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Aug 2010 21:42:33 +0200
Message-ID: <1281814953.23399.29.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey-Yi,

> When tx queue stuck, iwlwifi driver should detect and reload the firmware;
> different devices has different timing requirement, change the timeout
> value for 5000 series devices to avoid un-necessary firmware reload which
> can cause device become unstable.
> 
> This fixes:
> http://article.gmane.org/gmane.linux.kernel.wireless.general/53552
> 
> Wey-Yi Guy (2):
>   iwlwifi: long monitor timer
>   iwlwifi: use long monitor timer to avoid un-necessary reload

I think these qualify even to all -stable trees. I have at least seen it
with a 2.6.33.6 kernel from Fedora 13.

Regards

Marcel


