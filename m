Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:44920 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662AbZHURZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 13:25:50 -0400
Message-ID: <4A8ED89A.7090609@lwfinger.net>
Date: Fri, 21 Aug 2009 12:25:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-08-21
References: <20090821170324.GC8532@tuxdriver.com>
In-Reply-To: <20090821170324.GC8532@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Dave,
> 
> One more straggler for 2.6.31...without this rtl8187b devices simply
> don't work. :-(
> 
> The patch is small and isolated to rtl8187.  I think we should take
> it for 2.6.31.

Note: This patch should fix Bugzilla #13960, which is a regression
since 2.6.30. The OP has not yet reported back, but it fixed the same
condition on my computer.

