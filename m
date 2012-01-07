Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:3877 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab2AGEo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 23:44:26 -0500
From: "Mike Edenfield" <kutulu@kutulu.org>
To: "'Stanislaw Gruszka'" <sgruszka@redhat.com>
Cc: <linux-wireless@vger.kernel.org>
References: <012e01ccc67b$bfe90be0$3fbb23a0$@kutulu.org> <20120105113939.GC2222@redhat.com>
In-Reply-To: <20120105113939.GC2222@redhat.com>
Subject: RE: iwl3945: disassociating from current AP on rescan with kernels > 3.0
Date: Fri, 6 Jan 2012 23:44:32 -0500
Message-ID: <000301ccccf7$0c9fa800$25def800$@kutulu.org> (sfid-20120107_054430_807915_203ACDB8)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Problem looks more like software scanning issue, which we enable
> by default on 2.6.39. Can you check if disable_hw_scan=0 module
> parameter helps?

Wow, this appears to have fixed my problem, at least so far. I'm a little
worried because I had the module parameter set /on/ (disable_hw_scan=1) from
way back when I first built this laptop and couldn't stay connected to our
work LAN. I didn't realize that was on by default. I've switched it to be
off now and hopefully it won't be a problem.

Thanks for the heads up!

--Mike

