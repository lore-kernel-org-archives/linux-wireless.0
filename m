Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60248 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab3FMPaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 11:30:10 -0400
Date: Thu, 13 Jun 2013 11:18:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@ml01.01.org>
Subject: Re: [GIT] [3.10] NFC fixes
Message-ID: <20130613151821.GA3246@tuxdriver.com> (sfid-20130613_173019_173118_CAABDEC0)
References: <20130606152019.GT4793@zurbaran>
 <20130612182238.GG11589@tuxdriver.com>
 <20130613090209.GA7998@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130613090209.GA7998@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 13, 2013 at 11:02:09AM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> On Wed, Jun 12, 2013 at 02:22:38PM -0400, John W. Linville wrote:
> > Given recent events, I'm not sure that this is really acceptable as
> > a fix request.  The service bit and endianness in particular don't
> > sound like they are addressing big problems, and the other two don't
> > sound like they are really fixing any regressions either.
> > 
> > Can these wait for 3.11?
> I guess so, although they really are fixes.

I don't doubt that they are fixes, but I think that Dave is trying
to clamp down to only 'important' fixes -- data loss, crashes, etc.

> I'll queue them in nfc-next and will send you a pull request.
> Btw, are you going to merge wireless into wireless-next soon ?

I merged the wireless tree into wireless-next yesterday.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
