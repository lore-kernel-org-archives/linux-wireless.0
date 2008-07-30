Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53804
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761445AbYG3KE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 06:04:28 -0400
Date: Wed, 30 Jul 2008 03:04:28 -0700 (PDT)
Message-Id: <20080730.030428.20242736.davem@davemloft.net> (sfid-20080730_120450_701439_0D375AF4)
To: akpm@linux-foundation.org
Cc: zdenek.kabelac@gmail.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: INFO: possible recursive locking detected dev_deactivate
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080730024724.519f0662.akpm@linux-foundation.org>
References: <c4e36d110807290453h7381adb8l8b8785f434e968ac@mail.gmail.com>
	<20080730024724.519f0662.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 30 Jul 2008 02:47:24 -0700

> 
> (cc's added)

Well known problem and one that is being worked on.

The warnings are harmless, please ignore them for now.
