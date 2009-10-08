Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:64511 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755926AbZJHVAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 17:00:13 -0400
From: Frans Pop <elendil@planet.nl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for CPU"
Date: Thu, 8 Oct 2009 22:59:34 +0200
Cc: Arjan van de Ven <arjan@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-wireless@vger.kernel.org
References: <200910051500.55875.elendil@planet.nl> <200910081655.37485.elendil@planet.nl> <1255026217.6643.12.camel@marge.simson.net>
In-Reply-To: <1255026217.6643.12.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910082259.35204.elendil@planet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 October 2009, Mike Galbraith wrote:
> I still see very high latencies coming out of idle (last noted was >
> 300ms, NO_HZ) with this patch,
>
> Like this:
>
> Cause                                           Maximum    Percentage
> Scheduler: waiting for cpu                   604.2 msec        49.0 %

I'm not seeing anything even remotely like that.

I've tried quieting the system down as much as possible, but that made
no difference. I do have NO_HZ set; will send my full config privately.

If you'd still like me to try your patch I will, but I'm not sure if
that has much value.

Cheers,
FJP
