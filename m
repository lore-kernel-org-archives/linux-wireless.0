Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:39433 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbZHXVgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 17:36:53 -0400
MIME-Version: 1.0
In-Reply-To: <1251149659-32212-1-git-send-email-tomas.winkler@intel.com>
References: <1251149659-32212-1-git-send-email-tomas.winkler@intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 24 Aug 2009 14:36:35 -0700
Message-ID: <43e72e890908241436o5f30cfe6xa7bdda8b25ac082@mail.gmail.com>
Subject: Re: [PATCH 1/1] iwmc3200: add more SDIO device ids
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 24, 2009 at 2:34 PM, Tomas Winkler<tomas.winkler@intel.com> wrote:
> add WiFi BGN SKU and WiMAX 2.4GHz SKU device ids
>
> Cc:inaky.perez-gonzalez@intel.com
> Cc:cindy.h.kao@intel.com
> Cc:yi.zhu@intel.com
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Since it seems we are preferring to not do this for PCI for cases
where the ID will only be used for 1 device perhaps its best to remove
all those ids and stuff them directly into the intel driver itself
that will use it.

  Luis
