Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:11303 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757407Ab0LHBNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 20:13:36 -0500
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-052648812
	for <linux-wireless@vger.kernel.org>; Wed,  8 Dec 2010 10:13:34 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath5k: Use capabilities information for the number of TX queues
Date: Wed, 8 Dec 2010 10:13:06 +0900
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
References: <20101207020812.17506.40803.stgit@localhost6.localdomain6> <20101207140120.GA2700@tuxdriver.com>
In-Reply-To: <20101207140120.GA2700@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012081013.06034.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue December 7 2010 23:01:21 John W. Linville wrote:
> On Tue, Dec 07, 2010 at 11:08:12AM +0900, Bruno Randolf wrote:
> > One thing I missed in my WME series: Older hardware does not have enough
> > hardware queues to support WME. In this case we just set up one data
> > queue. Use the capability information to decide how many queues to set
> > up.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > 
> > --
> > 
> > resend, seems like it got lost somewhere in a queue ;)
> 
> Did you originally post with a different subject?  The MARC archive
> doesn't seem to see any prior posting.

Sorry, I accidentially posted only to the ath5k lists before. My fault.

bruno
