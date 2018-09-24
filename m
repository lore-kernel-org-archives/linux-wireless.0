Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52954 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbeIXPP4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 11:15:56 -0400
Subject: Re: [PATCH] mt76: usb: include <linux/module.h> and <linux/export.h>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20180924083105.29516-1-johannes@sipsolutions.net>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <b4e04c79-5f8b-2b1b-b13e-a61b277dabd9@nbd.name> (sfid-20180924_111454_327617_FF273915)
Date: Mon, 24 Sep 2018 11:14:48 +0200
MIME-Version: 1.0
In-Reply-To: <20180924083105.29516-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-24 10:31, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This file uses MODULE_AUTHOR() etc. as well as EXPORT_SYMBOL_GPL()
> so should include the necessary header files for it.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Replaced with a more complete fix.

Thanks,

- Felix
