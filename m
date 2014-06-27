Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaF0EJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2014 00:09:03 -0400
Date: Thu, 26 Jun 2014 20:20:52 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/17] staging: vt6656: conversion to mac80211
Message-ID: <20140627002052.GA26828@kroah.com> (sfid-20140627_060906_907450_37AC7DEB)
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
 <1403764178.4131.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403764178.4131.5.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 26, 2014 at 08:29:38AM +0200, Johannes Berg wrote:
> On Wed, 2014-06-25 at 21:14 +0100, Malcolm Priestley wrote:
> > The patches in this series convert the driver to mac80211.
> 
> Impressive! I didn't think it was actually *possible* to convert a
> driver, I used to think a rewrite with selective copy/pasting would be
> the right approach :-)

I agree, very nice job with all of this, great to see this happen.

greg k-h
