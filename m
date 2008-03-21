Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:36104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYCUIpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2008 04:45:33 -0400
Date: Fri, 21 Mar 2008 09:45:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, Daniel Drake <dsd@gentoo.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH/RFC v4] introduce HAVE_UNALIGNED_ACCESS_SUPPORT Kconfig
	symbol
Message-ID: <20080321084516.GA20420@elte.hu> (sfid-20080321_084542_799411_67BAD4B7)
References: <1206023695.16475.137.camel@johannes.berg> <20080320181310.GA17884@uranus.ravnborg.org> <1206038373.16475.150.camel@johannes.berg> <1206038734.16475.153.camel@johannes.berg> <20080320194101.GC17884@uranus.ravnborg.org> <1206042658.16475.158.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1206042658.16475.158.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


* Johannes Berg <johannes@sipsolutions.net> wrote:

> --- everything.orig/arch/x86/Kconfig	2008-03-20 15:30:38.000000000 +0100
> +++ everything/arch/x86/Kconfig	2008-03-20 19:38:08.000000000 +0100
> @@ -23,6 +23,7 @@ config X86
>  	select HAVE_KPROBES
>  	select HAVE_KRETPROBES
>  	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
> +	select HAVE_UNALIGNED_ACCESS_SUPPORT

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
