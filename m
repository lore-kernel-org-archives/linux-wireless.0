Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:47897 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932548Ab1EXRn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 13:43:56 -0400
Date: Tue, 24 May 2011 10:43:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: arne.fitzenreiter@gmx.de
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] compat: fix kfifo taint's kernel (missing license info)
Message-Id: <20110524104351.b23f7a3f.rdunlap@xenotime.net> (sfid-20110524_194359_728328_6467501F)
In-Reply-To: <20110524173301.24960@gmx.net>
References: <20110524173301.24960@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 24 May 2011 19:33:01 +0200 arne.fitzenreiter@gmx.de wrote:

> compat wireless kfifo modul has no MODULE_LICENSE. The kernel does'nt like this.
> 
> Sorry for the last empty mail...


OK, I'm not familiar with how the compat patches work, but...

in what kernel can kfifo be built as a loadable module?

or if kfifo is builtin (vs. being built as a loadable module), does the
missing license info message still happen?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
