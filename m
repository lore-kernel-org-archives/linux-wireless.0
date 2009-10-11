Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42250
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674AbZJKB64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2009 21:58:56 -0400
Date: Sat, 10 Oct 2009 18:58:52 -0700 (PDT)
Message-Id: <20091010.185852.133969433.davem@davemloft.net>
To: tomasw@gmail.com
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	yi.zhu@intel.com, inaky.perez-gonzalez@intel.com,
	cindy.h.kao@intel.com, guy.cohen@intel.com,
	ron.rindjunsky@intel.com, tomas.winkler@intel.com
Subject: Re: [PATCH 1/3] iwmc3200top: Add Intel Wireless MultiCom 3200 top
 driver.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1ba2fa240910100238s709c31d3s6cb612f502b1086f@mail.gmail.com>
References: <1253662724-16497-1-git-send-email-tomas.winkler@intel.com>
	<1253662724-16497-2-git-send-email-tomas.winkler@intel.com>
	<1ba2fa240910100238s709c31d3s6cb612f502b1086f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomasw@gmail.com>
Date: Sat, 10 Oct 2009 11:38:50 +0200

> On Wed, Sep 23, 2009 at 1:38 AM, Tomas Winkler <tomas.winkler@intel.com> wrote:
>> This patch adds Intel Wireless MultiCom 3200 top driver.
>> IWMC3200 is 4Wireless Com CHIP (GPS/BT/WiFi/WiMAX).
>> Top driver is responsible for device initialization and firmware download.
>> Firmware handled by top is responsible for top itself and
>> as well as bluetooth and GPS coms. (Wifi and WiMax provide their own
>> firmware)
>> In addition top driver is used to retrieve firmware logs
>> and supports other debugging features
>>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> 
> Dave,
> are you going to merge this one?
> iwmc3200wifi and i200m-sdio which are already merged are usless without it

If it's not in netdev patchwork, I don't plan to add it.

If it is in patchwork, then it's in my backlog and I'll get to it.

People should never really have to ask me these questions, that's one
of the main points of:

	http://patchwork.ozlabs.org/project/netdev/list/

You can always see there what's "pending".
