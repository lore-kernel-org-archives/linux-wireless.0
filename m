Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:36844 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbZJJJj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2009 05:39:28 -0400
MIME-Version: 1.0
In-Reply-To: <1253662724-16497-2-git-send-email-tomas.winkler@intel.com>
References: <1253662724-16497-1-git-send-email-tomas.winkler@intel.com>
	 <1253662724-16497-2-git-send-email-tomas.winkler@intel.com>
Date: Sat, 10 Oct 2009 11:38:50 +0200
Message-ID: <1ba2fa240910100238s709c31d3s6cb612f502b1086f@mail.gmail.com>
Subject: Re: [PATCH 1/3] iwmc3200top: Add Intel Wireless MultiCom 3200 top
	driver.
From: Tomas Winkler <tomasw@gmail.com>
To: davem@davemloft.net, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org
Cc: yi.zhu@intel.com, inaky.perez-gonzalez@intel.com,
	cindy.h.kao@intel.com, guy.cohen@intel.com,
	ron.rindjunsky@intel.com, Tomas Winkler <tomas.winkler@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2009 at 1:38 AM, Tomas Winkler <tomas.winkler@intel.com> wrote:
> This patch adds Intel Wireless MultiCom 3200 top driver.
> IWMC3200 is 4Wireless Com CHIP (GPS/BT/WiFi/WiMAX).
> Top driver is responsible for device initialization and firmware download.
> Firmware handled by top is responsible for top itself and
> as well as bluetooth and GPS coms. (Wifi and WiMax provide their own
> firmware)
> In addition top driver is used to retrieve firmware logs
> and supports other debugging features
>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Dave,
are you going to merge this one?
iwmc3200wifi and i200m-sdio which are already merged are usless without it

Thanks
Tomas
