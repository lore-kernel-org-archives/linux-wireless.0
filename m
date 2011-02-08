Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43066 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1BHMtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 07:49:36 -0500
Received: by bwz15 with SMTP id 15so5980253bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 04:49:35 -0800 (PST)
From: Marek Vasut <marek.vasut@gmail.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Subject: Re: [PATCH 0/3] libertas_spi fixes
Date: Tue, 8 Feb 2011 13:52:50 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com> <1296759294.9471.0.camel@dcbw.foobar.com> <201102032059.27128.anarsoul@gmail.com>
In-Reply-To: <201102032059.27128.anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201102081352.51062.marek.vasut@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 February 2011 19:59:26 Vasily Khoruzhick wrote:
> On Thursday 03 February 2011 20:54:52 Dan Williams wrote:
> > On Mon, 2011-01-31 at 14:52 -0500, John W. Linville wrote:
> > > On Fri, Jan 21, 2011 at 10:44:47PM +0200, Vasily Khoruzhick wrote:
> > > > This series attempts to fix libertas_spi bug (it calls functions that
> > > > may sleep from atomic context) and add pm support to libertas_spi.
> > > > Tested on Zipit Z2 device.
> > > 
> > > Are the libertas folks OK with this series?
> > 
> > 1 & 2 yes, I'll ack them if you like.  But I think we were waiting on a
> > response from Vasily about #3, specifically Marek's question about "can
> > this be done from the resume handler instead of a workqueue".
> 
> Nope, it can't, I tried to do so and it hangs on resume (console cursor
> flickers, so it's not complete hang, but it does not return control to
> shell). Can investigate why if you want.

Please do. It's not that I want to block this, but the code seems quick enough.

Btw. Dan, sorry for not looking into this as I promised, but as I can see, it 
isn't needed anymore. Open Source is so awesome at this :-)
> 
> Regards
> Vasily
