Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tayrelbas04.tay.hp.com ([161.114.80.247]:58040 "EHLO
	tayrelbas04.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbXGLQu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 12:50:29 -0400
Date: Thu, 12 Jul 2007 09:49:18 -0700
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Dan Williams <dcbw@redhat.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6] SoftMAC : fix duplicate display of channel in scan
Message-ID: <20070712164918.GC13445@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070710184155.GA6955@bougret.hpl.hp.com> <4693DD18.1010905@lwfinger.net> <1184211018.9446.0.camel@localhost.localdomain> <20070712163440.GA13445@bougret.hpl.hp.com> <46965977.7020807@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46965977.7020807@lwfinger.net>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 12, 2007 at 11:40:23AM -0500, Larry Finger wrote:
> Jean Tourrilhes wrote:
> >
> >	Well, I actually like forcing driver to use frequency, because
> >that's an absolute physical measure and contains more meaning.
> 
> Yes, but it is easier to keep a channel number in your head than a 
> frequency.

	That's why iwlist display both in 'iwlist freq' and 'iwlist scan'.

> Larry

	Jean
