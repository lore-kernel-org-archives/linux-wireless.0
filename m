Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52164 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab1DMUSf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 16:18:35 -0400
Message-ID: <4DA60515.6000004@hauke-m.de>
Date: Wed, 13 Apr 2011 22:18:29 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Tomas Winkler <tomas.winkler@intel.com>
CC: mcgrof@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
Subject: Re: [compat 1/1] compat: add license and other module params to kfifo
References: <1302530175-24451-1-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1302530175-24451-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

On 04/11/2011 03:56 PM, Tomas Winkler wrote:
> The module taints the kernel if the license is not specified
> 
> Add also module description
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
I send a patch including kfifo.ko into compat.ko some days ago [0], but
it was not yet apply. If kfifo is integrated in compat.ko this patch
will cause problems. As kifo.ko is small I think it is better to get rid
of this extra module and integrate it into compat.ko.

[0]: https://patchwork.kernel.org/patch/692651/

Hauke
