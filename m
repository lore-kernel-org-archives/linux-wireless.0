Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58267 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbcEPLqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 07:46:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: andy <lgkbiti@163.com>, linux-wireless@vger.kernel.org
Subject: Re: wifi driver crashes openwrt device
References: <loom.20160510T171307-937@post.gmane.org>
	<20160515174705.GA11620@localhost>
Date: Mon, 16 May 2016 14:46:07 +0300
In-Reply-To: <20160515174705.GA11620@localhost> (Bob Copeland's message of
	"Sun, 15 May 2016 13:47:05 -0400")
Message-ID: <87d1omp6o0.fsf@purkki.adurom.net> (sfid-20160516_134616_361804_ABFBAA07)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> On Tue, May 10, 2016 at 03:17:25PM +0000, andy wrote:
>> hello, every body.
>>   I developed an openwrt device based on git clone 
>> git://git.openwrt.org/15.05/openwrt.git.
>>   I found that my device rebooted during wifi initializing sometimes, maybe 
>> one in twenty. 
>>   The wifi driver is compat-wireless-2016-01-10.tar.bz2.
>>   Could somebody give some hint or help me to resolve this wired issue?
>>   Thank you very much.
>
> Hi Andy,
>
> You will probably need to capture a stack trace from the device in order
> for someone to be able to help, otherwise we can only guess.  A serial
> console can help with that.

Didn't openwrt have a some sort ramoops facility to collect the last
kernel logs before a crash? I don't recall the name right now but I'm
pretty sure I used it with one of our APs few years back. That might
help (or not).

-- 
Kalle Valo
