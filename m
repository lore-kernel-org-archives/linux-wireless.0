Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.scalarmail.ca ([98.158.95.75]:45754 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752071Ab1LPO5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 09:57:47 -0500
Date: Fri, 16 Dec 2011 09:48:04 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: unexpected taint message
Message-ID: <20111216144804.GA11693@elliptictech.com> (sfid-20111216_155752_194698_6B138BFD)
References: <4EEB0EFC.5000302@broadcom.com>
 <1324038636.3429.1.camel@jlt3.sipsolutions.net>
 <4EEB4D61.80602@lwfinger.net>
 <1324043939.3429.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1324043939.3429.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-12-16 14:58 +0100, Johannes Berg wrote:
> Hmm. I wish OOT didn't disable lockdep, we do a lot of development with
> modules OOT because the turnaround is faster/easier (for not so
> experienced developers). Worst case we can patch it out of the base
> kernel I guess...

Indeed, but the good news is that we should finally be able to put this
issue behind us soon(ish).

  https://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commit;h=9ec84acee1e221d99dc33237bff5e82839d10cc0

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

