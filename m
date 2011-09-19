Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37315 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab1ISS3y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 14:29:54 -0400
Message-ID: <4E778A1C.5020206@openwrt.org> (sfid-20110919_202957_951261_A6670E11)
Date: Mon, 19 Sep 2011 20:29:48 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH v2 3/4] ath: remove ath_regulatory::current_rd_ext
References: <1316453903-75710-1-git-send-email-nbd@openwrt.org> <1316453903-75710-2-git-send-email-nbd@openwrt.org> <1316453903-75710-3-git-send-email-nbd@openwrt.org> <CAB=NE6UhC=am2aVXwf+v4g7ME_49Nv47SZwSNetLgJpRV-=BkA@mail.gmail.com>
In-Reply-To: <CAB=NE6UhC=am2aVXwf+v4g7ME_49Nv47SZwSNetLgJpRV-=BkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-19 8:18 PM, Luis R. Rodriguez wrote:
> On Mon, Sep 19, 2011 at 10:38 AM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>
> Can you document on the patch commit log why you do remove this.
Because it's unused
