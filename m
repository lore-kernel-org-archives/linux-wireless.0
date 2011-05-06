Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38876 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752479Ab1EFW1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 18:27:06 -0400
Date: Fri, 6 May 2011 23:28:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: <akpm@linux-foundation.org>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <hpa@zytor.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<allen.kao@atheros.com>, <roman.gezikov@atheros.com>,
	<joonas.viskari@atheros.com>
Subject: Re: [RFC 2/2] x86: add Atheros ar1520 platform support for mrst
Message-ID: <20110506232814.3ca7b943@lxorguk.ukuu.org.uk> (sfid-20110507_002725_240290_132C813B)
In-Reply-To: <1304719780-27347-3-git-send-email-lrodriguez@atheros.com>
References: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
	<1304719780-27347-3-git-send-email-lrodriguez@atheros.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 6 May 2011 15:09:40 -0700
"Luis R. Rodriguez" <lrodriguez@atheros.com> wrote:

> From: Allen Kao <allen.kao@atheros.com>
> 
> This adds platform driver support for Atheros ar1520 GPS device
> on the Intel Moorestown Low Power Intel Architecture (LPIA) based
> Moblin Internet Device (MID) platform.

NAK - for the same reasons as before, and the same NAK you already got on
the other list.

No open user space or sufficient API docs to make use of the kernel
driver and write your own = not a candidate for submission. Same for the
3D graphics on that platform.

Alan
