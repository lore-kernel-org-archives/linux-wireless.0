Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:55982 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3LOPsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 10:48:46 -0500
Date: Sun, 15 Dec 2013 16:48:43 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-rt-users@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC 00/10] make iwlwifi RT friendly
Message-ID: <20131215154843.GL31090@linutronix.de> (sfid-20131215_164904_133176_1B7E222D)
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Emmanuel Grumbach | 2013-12-11 10:33:35 [+0200]:

>RT folks have raised issues with iwlwifi wrt. RT kernel some time
>ago. Johannes had a few patches to address this, but I had a few
>concerns with them. This series tries to address the RT concerns:
>* we don't do anything in hard-irq context besides stopping the
>  interrupts in the device.
>* the interrupt cause is read from the irq handler and is handled
>  there.

Thanks for the patches. I haven't yet looked at them I doubt I manage it
anytime soon. Could you please answer one question: Do you grab any
locks in the primary interrupt handler?

Sebastian
