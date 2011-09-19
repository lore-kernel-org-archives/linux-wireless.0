Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f42.google.com ([209.85.216.42]:58239 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab1ISSTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 14:19:05 -0400
Received: by qwi4 with SMTP id 4so17962845qwi.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 11:19:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316453903-75710-3-git-send-email-nbd@openwrt.org>
References: <1316453903-75710-1-git-send-email-nbd@openwrt.org>
 <1316453903-75710-2-git-send-email-nbd@openwrt.org> <1316453903-75710-3-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 19 Sep 2011 11:18:44 -0700
Message-ID: <CAB=NE6UhC=am2aVXwf+v4g7ME_49Nv47SZwSNetLgJpRV-=BkA@mail.gmail.com> (sfid-20110919_201913_061958_D6E5647A)
Subject: Re: [PATCH v2 3/4] ath: remove ath_regulatory::current_rd_ext
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 10:38 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Can you document on the patch commit log why you do remove this.

  Luis
