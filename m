Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pointone.de ([81.92.162.26]:1427 "EHLO mail.pointone.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754756AbXHFJPR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 05:15:17 -0400
Message-ID: <46B6DF83.8080507@in.tum.de>
Date: Mon, 06 Aug 2007 10:44:51 +0200
From: =?ISO-8859-1?Q?Christian_Sch=E4fer?= <schaefer@in.tum.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [BUG] timer.h
References: <46B1F896.8090005@in.tum.de> <46B2EA43.8070305@in.tum.de>	 <20070803123240.519c5a38.akpm@linux-foundation.org> <1186382146.21957.40.camel@johannes.berg>
In-Reply-To: <1186382146.21957.40.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>>> I was able to reproduce the bug without a tainted kernel (i.e. without 
>>> the nvidia binary module). Please let me know if you need more infos.
> What sort of wireless code are you using? That _rtl suffix *looks* like
> some weird vendor driver added _rtl to all function and module names.
> It's definitely not pristine upstream source; looks to me like vendor
> source to that r8187 module you have since the official driver is called
> rtl8187.

The driver source is from [1] (I think it comes from Realtek) and 
patched with the injection-patch taken from the aircrack-project (for 
more background see [2]).

However this issue was before I used the current 2.6.23-rc2 kernel with 
native r8187 support where no such problem occurred untill today.


Chris

[1] ftp://202.65.194.18/cn/wlan/rtl8187_linux_26.1010.zip
[2] http://www.aircrack-ng.org/doku.php?id=r8187

