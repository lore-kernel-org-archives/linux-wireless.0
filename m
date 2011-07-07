Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab1GGWHV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 18:07:21 -0400
Date: Thu, 7 Jul 2011 15:04:36 -0700
From: Greg KH <gregkh@suse.de>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Pavel Roskin <proski@gnu.org>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: [RFC] Move brcm80211 to mainline
Message-ID: <20110707220436.GA14300@suse.de> (sfid-20110708_000725_080842_AF80DAD5)
References: <20110707002034.GA17885@broadcom.com>
 <CACna6rx5EyZ-=2XgWawdN_Qu2t1K1sdHZydZFW6=TiX2QUwMfw@mail.gmail.com>
 <4E1504A3.1070801@gnu.org>
 <20110707014512.GA21087@suse.de>
 <20110707144628.GF23944@broadcom.com>
 <20110707145822.GA29241@suse.de>
 <20110707215537.GS23944@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110707215537.GS23944@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 07, 2011 at 02:55:37PM -0700, Henry Ptasinski wrote:
> Building some cross-compiler toolchains now.  SPARC hardware to do anything
> native with seems to be getting very scarce, and trying to fit a PCIe minicard
> into one might be challenging ...

That doesn't matter.  The point is that the BE code is obviously wrong
and can't even compile.  Your code should be arch-neutral as it's just a
driver.

greg k-h
