Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40501 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1CUPPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 11:15:12 -0400
Date: Mon, 21 Mar 2011 11:14:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	George Kashperko <george@znau.edu.ua>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: new utility kernel module for detecting cores in newer chipsets
Message-ID: <20110321151422.GB3731@tuxdriver.com>
References: <op.vsmyhmei3ri7v4@arend-laptop>
 <20110320145421.GA13962@kroah.com>
 <op.vsnd1a1i3ri7v4@arend-laptop>
 <20110320162200.GA17030@kroah.com>
 <op.vsng7q1j3ri7v4@arend-laptop>
 <20110320185216.GD19375@kroah.com>
 <AANLkTimEGR-8zhbMQpcAzYkuZ8fHkhj1bOQrb3rShfsP@mail.gmail.com>
 <20110321140505.GA7321@kroah.com>
 <AANLkTi=1eGo7uvP8Uy32yQezhGJTHYkHpEyX9vF=PujF@mail.gmail.com>
 <op.vso77ddp3ri7v4@arend-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <op.vso77ddp3ri7v4@arend-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 21, 2011 at 04:05:27PM +0100, Arend van Spriel wrote:

> To summarize this, my main issue (and Michael's, I think) is with
> the dependency being imposed between ai and ssb. Having two
> completely independent modules really makes more sense.

FWIW, this approach makes the most sense to me as well.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
