Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39492 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab3FRPwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:52:13 -0400
Message-ID: <1371570723.22256.0.camel@jlt4.sipsolutions.net> (sfid-20130618_175218_216759_83CD1FC4)
Subject: Re: Lots of confusion on bss refcounting.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 18 Jun 2013 17:52:03 +0200
In-Reply-To: <51C08119.3000407@candelatech.com>
References: <51BF5A53.8050100@candelatech.com>
	   (sfid-20130617_205007_448068_E9E81DD2) <1371495758.8168.3.camel@jlt4.sipsolutions.net>
	  <51BF5ED4.9010704@candelatech.com> <51BF8040.2000408@candelatech.com>
	  <51BFAA34.1020407@candelatech.com>
	 <1371559771.8318.12.camel@jlt4.sipsolutions.net>
	 <51C08119.3000407@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > You mean ->current_bss? That should be handled in all the callbacks in
> > sme.c or so
> 
> Looks like much of the action happens on work-queues.  I'm wondering if
> we managed to delete wdev objects before we have completely cleaned up
> in some cases...

Don't we flush work structs appropriately?

johannes

