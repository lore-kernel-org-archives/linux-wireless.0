Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:59430 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3LORu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 12:50:27 -0500
Message-ID: <52ADEBDF.5060406@gmail.com> (sfid-20131215_185033_295942_57FABA8A)
Date: Sun, 15 Dec 2013 19:50:23 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-rt-users@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC 00/10] make iwlwifi RT friendly
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com> <20131215154843.GL31090@linutronix.de> <52ADEAAF.3080107@gmail.com> <52ADEB0D.3080306@linutronix.de>
In-Reply-To: <52ADEB0D.3080306@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/15/2013 07:46 PM, Sebastian Andrzej Siewior wrote:
> On 12/15/2013 06:45 PM, Emmanuel Grumbach wrote:
>> No we don't. The primary interrupt just tells the hardware to stop
>> firing interrupts and wakes up the thread as written above.
> 
> Sounds great then.
> 

Ok - I guess I'll submit then internally then before we send them upstream.
