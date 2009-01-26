Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:37630 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZAZSos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 13:44:48 -0500
Received: by ewy14 with SMTP id 14so896696ewy.13
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 10:44:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090127053357.689baabe@s6510>
References: <20090127053357.689baabe@s6510>
Date: Mon, 26 Jan 2009 19:44:46 +0100
Message-ID: <69e28c910901261044r1a078240rb7d16306ef5a2b09@mail.gmail.com> (sfid-20090126_194454_248268_ABFC2487)
Subject: Re: [PATCH] hostap: convert to net_device_ops
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 26, 2009 at 7:33 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> +       dev->netdev_ops = &hostap_netdev-ops;

I guess this should be
+       dev->netdev_ops = &hostap_netdev_ops;

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
