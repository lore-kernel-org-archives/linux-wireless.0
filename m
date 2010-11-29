Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34272
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056Ab0K2B0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Nov 2010 20:26:31 -0500
Date: Sun, 28 Nov 2010 17:26:57 -0800 (PST)
Message-Id: <20101128.172657.193710679.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] drivers/net: Remove unnecessary [kv][mcz]alloc
 casts
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1290934782.git.joe@perches.com>
References: <cover.1290934782.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches <joe@perches.com>
Date: Sun, 28 Nov 2010 01:05:42 -0800

> These are the last remaining alloc casts in drivers/net...
> 
> Joe Perches (4):
>   netxen: remove unnecessary [kv][mcz]alloc casts
>   qlcnic: remove unnecessary [kv][mcz]alloc casts
>   vxge: remove unnecessary [kv][mcz]alloc casts
>   zd1211rw: remove unnecessary [kv][mcz]alloc casts

All applied, using v2 of patch #4.

Thanks.
