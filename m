Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38884 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753211Ab1EFWaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 18:30:10 -0400
Date: Fri, 6 May 2011 23:31:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: <akpm@linux-foundation.org>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <hpa@zytor.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<allen.kao@atheros.com>, <roman.gezikov@atheros.com>,
	<joonas.viskari@atheros.com>
Subject: Re: [PATCH] x86: fix mrst sparse complaints
Message-ID: <20110506233118.76b092ad@lxorguk.ukuu.org.uk> (sfid-20110507_003057_327195_3BD858A0)
In-Reply-To: <1304719209-26913-1-git-send-email-lrodriguez@atheros.com>
References: <1304719209-26913-1-git-send-email-lrodriguez@atheros.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 6 May 2011 15:00:09 -0700
"Luis R. Rodriguez" <lrodriguez@atheros.com> wrote:

> This fixes these few sparse complaints:
> 
>   CHECK   arch/x86/platform/mrst/mrst.c
> arch/x86/platform/mrst/mrst.c:197:13: warning: symbol 'mrst_time_init' was not declared. Should it be static?
> arch/x86/platform/mrst/mrst.c:219:16: warning: symbol 'mrst_arch_setup' was not declared. Should it be static?
>   CC      arch/x86/platform/mrst/mrst.o

Please Cc me on Moorestown/Medfield tree stuff. Looks sane enough.

Alan
