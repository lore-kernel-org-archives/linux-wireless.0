Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:56402 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab3LORq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 12:46:58 -0500
Message-ID: <52ADEB0D.3080306@linutronix.de> (sfid-20131215_184703_909931_7A248C72)
Date: Sun, 15 Dec 2013 18:46:53 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-rt-users@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC 00/10] make iwlwifi RT friendly
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com> <20131215154843.GL31090@linutronix.de> <52ADEAAF.3080107@gmail.com>
In-Reply-To: <52ADEAAF.3080107@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2013 06:45 PM, Emmanuel Grumbach wrote:
> No we don't. The primary interrupt just tells the hardware to stop
> firing interrupts and wakes up the thread as written above.

Sounds great then.

Sebastian
