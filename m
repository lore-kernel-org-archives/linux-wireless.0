Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60337 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248Ab3FMJCr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 05:02:47 -0400
Date: Thu, 13 Jun 2013 11:02:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@ml01.01.org>
Subject: Re: [GIT] [3.10] NFC fixes
Message-ID: <20130613090209.GA7998@zurbaran> (sfid-20130613_110250_747815_816E03AB)
References: <20130606152019.GT4793@zurbaran>
 <20130612182238.GG11589@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130612182238.GG11589@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Wed, Jun 12, 2013 at 02:22:38PM -0400, John W. Linville wrote:
> Given recent events, I'm not sure that this is really acceptable as
> a fix request.  The service bit and endianness in particular don't
> sound like they are addressing big problems, and the other two don't
> sound like they are really fixing any regressions either.
> 
> Can these wait for 3.11?
I guess so, although they really are fixes.
I'll queue them in nfc-next and will send you a pull request.
Btw, are you going to merge wireless into wireless-next soon ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
