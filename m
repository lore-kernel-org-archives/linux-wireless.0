Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbbEaAik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2015 20:38:40 -0400
Date: Sun, 31 May 2015 08:59:41 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: wilc1000: Fix some compile warnings
Message-ID: <20150530235941.GB20036@kroah.com> (sfid-20150531_023845_041347_809754EE)
References: <1433018659-25958-1-git-send-email-kholmanskikh.s.s@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433018659-25958-1-git-send-email-kholmanskikh.s.s@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 30, 2015 at 11:44:18PM +0300, Stanislav Kholmanskikh wrote:
> This patch reduces (a little bit) the amount of compile time
> warnings.
> 
> The change of WILC_WFI_init_mon_interface() prototype seems to be ok,
> because alloc_netdev() also expects 'const char *name'.

You are doing different types of fixes here, please be explicit about
what you are doing and break this up into logical patches that each only
do one type of thing.

thanks,

greg k-h
