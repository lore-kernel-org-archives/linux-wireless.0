Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:36879 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab1LMJ2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 04:28:33 -0500
Received: by laah2 with SMTP id h2so1488240laa.3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 01:28:30 -0800 (PST)
Subject: Re: [PATCH 1/3] wl12xx: fix testmode test/interrogate commands
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1323166507-32470-1-git-send-email-eliad@wizery.com>
References: <1323166507-32470-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Dec 2011 11:28:25 +0200
Message-ID: <1323768505.2800.83.camel@cumari> (sfid-20111213_102838_234194_66DD18A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-06 at 12:15 +0200, Eliad Peller wrote: 
> fix several issues in testmode test/interrogate commands:
> 1. check the driver state is not OFF.
> 2. wakeup the chip from elp (if needed)
> 3. fix memory leak in wl1271_tm_cmd_interrogate()
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Forgot to reply earlier.  But just for the record and consistency, this
series has been applied and pushed.

-- 
Cheers,
Luca.

