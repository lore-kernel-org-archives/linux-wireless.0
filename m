Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46709 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZEUHMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 03:12:17 -0400
Received: by fxm2 with SMTP id 2so852399fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 00:12:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242872340-27417-2-git-send-email-yi.zhu@intel.com>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	 <1242872340-27417-2-git-send-email-yi.zhu@intel.com>
Date: Thu, 21 May 2009 09:12:17 +0200
Message-ID: <f6ca9fed0905210012t2b494db5w3169ef2e8db2b04b@mail.gmail.com>
Subject: Re: [PATCH 1/2] wireless: move some utility functions from mac80211
	to cfg80211
From: drago01 <drago01@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Samuel Ortiz <samuel.ortiz@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2009 at 4:18 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> The patch moves some utility functions from mac80211 to cfg80211.
> Because these functions are doing generic 802.11 operations so they
> are not mac80211 specific. The moving allows some fullmac drivers
> to be also benefit from these utility functions.

Isn't lib80211 a better place for those ?
Its purpose is sharing code between fullmac and softmac drivers.
