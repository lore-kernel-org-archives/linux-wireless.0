Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbbIITwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 15:52:36 -0400
Date: Wed, 9 Sep 2015 11:15:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com
Subject: Re: [PATCH 01/30] staging: wilc1000: rename WILC_WFI_CfgSetChannel
Message-ID: <20150909181558.GA30416@kroah.com> (sfid-20150909_215246_501923_553F2551)
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 09, 2015 at 12:55:38AM +0900, Chaehyun Lim wrote:
> This patch replaces WILC_WFI_CfgSetChannel with
> wilc_cfg80211_set_monitor_channel to avoid CamelCase.

Like was said, this is now longer, how about something "simple" like
wilc_set_channel()?

Actually, as this is a static function, set_channel() would work, no
need to prefix static functions as it's obvious it is "wilc".

Same for all of the other patches in this series, can you please redo
them to be simpler?

thanks,

greg k-h
