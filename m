Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tayrelbas03.tay.hp.com ([161.114.80.246]:45993 "EHLO
	tayrelbas03.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761823AbXGLBCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 21:02:01 -0400
Date: Wed, 11 Jul 2007 17:46:34 -0700
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6] libertas : fix a few wext abuses...
Message-ID: <20070712004634.GA12148@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070710213706.GA7929@bougret.hpl.hp.com> <1184188789.28850.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1184188789.28850.4.camel@localhost.localdomain>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 11, 2007 at 05:19:48PM -0400, Dan Williams wrote:
> On Tue, 2007-07-10 at 14:37 -0700, Jean Tourrilhes wrote:
> > 	Hi guys,
> > 
> > 	I have no clue to who is the official libertas maintainer, so
> > please tell me where to send this patch.
> 
> Me, actually :)  Thanks for the patch.
> 
> Dan

	By the way, from my glancing at the driver, the Libertas
driver do select CONFIG_IEEE80211, and then doesn't use it ? It seems
to force loading a modules that is not needed.

	Jean
