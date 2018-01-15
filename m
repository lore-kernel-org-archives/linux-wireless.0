Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37086 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964915AbeAONEP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 08:04:15 -0500
Message-ID: <1516021453.410.24.camel@sipsolutions.net> (sfid-20180115_140425_094411_88044CF2)
Subject: Re: [RFC v2 2/5] nl80211: Add CMD_CONTROL_PORT_FRAME API
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 15 Jan 2018 14:04:13 +0100
In-Reply-To: <20180110170938.2341-3-denkenz@gmail.com> (sfid-20180110_180954_446002_3E444A40)
References: <20180110170938.2341-1-denkenz@gmail.com>
         <20180110170938.2341-3-denkenz@gmail.com>
         (sfid-20180110_180954_446002_3E444A40)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can only nitpick on this patch ...

> +static int __nl80211_control_port(struct net_device *dev,
> +				  const u8 *buf, size_t len,
> +				  const u8 *addr, u16 proto,
> +				  bool unencrypted, gfp_t gfp)

but that could use an "rx" in the function name :)

johannes
