Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:29890 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbZAUWMl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 17:12:41 -0500
Subject: Re: [Orinoco-devel] [PATCH] orinoco: convert to struct
 net_device_ops
From: Pavel Roskin <proski@gnu.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200901212046.48426.arvidjaar@mail.ru>
References: <200901212046.48426.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 17:12:37 -0500
Message-Id: <1232575957.24229.1.camel@dv> (sfid-20090121_231246_238448_0F9875F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-01-21 at 20:46 +0300, Andrey Borzenkov wrote:
> Subject: [PATCH] orinoco: convert to struct net_device_ops
> From: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> No functional changes; use new kernel interface for netdev methods.
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

Signed-off-by: Pavel Roskin <proski@gnu.org>

Verified by undefining CONFIG_COMPAT_NET_DEV_OPS in netdevice.h

-- 
Regards,
Pavel Roskin
