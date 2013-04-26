Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37127 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab3DZOXG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 10:23:06 -0400
Date: Fri, 26 Apr 2013 16:23:03 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: linux-nfc@vger.kernel.org, linux-wireless@vger.kernel.org,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org
Subject: Re: NFC cleanup request
Message-ID: <20130426142303.GC4796@zurbaran> (sfid-20130426_162315_364159_AEDB190D)
References: <20130425.160937.1062961248509351598.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130425.160937.1062961248509351598.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

On Thu, Apr 25, 2013 at 04:09:37PM -0400, David Miller wrote:
> 
> Please do not have object targets in a directory other than the one
> the Makefile is in, that is what net/nfc/Makefile is doing with the
> stuff under llcp/
> 
> It means that you can't do:
> 
> 	make net/nfc/llcp/sock.o
> 
> which I use on pretty much every patch I apply as a quick sanity
> check before I fire off a full allmodconfig build.
Sorry about that.
I sent a pull request to John that will fix that issue.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
