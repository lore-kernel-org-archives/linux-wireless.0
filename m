Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbXHALED (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 07:04:03 -0400
Subject: Re: libertas: blows chunks on failed firmware load
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Andy Green <andy@warmcat.com>
In-Reply-To: <200708011131.22390.hs4233@mail.mn-solutions.de>
References: <46AF913F.9010006@warmcat.com>
	 <200708010900.00514.hs4233@mail.mn-solutions.de>
	 <46B04704.3000409@warmcat.com>
	 <200708011131.22390.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 07:01:30 -0400
Message-Id: <1185966090.29690.0.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-08-01 at 11:31 +0200, Holger Schurig wrote:
> > Sure I will try it tonight, where should I go to get it?  The
> > only trees with "libertas" in the name on git.kernel.org don't
> > seem to be the ones.
> 
> My driver is for sure in the libertas-dev tree from the OLPC 
> people. The SVN project that contains the firmware cutter also 
> contains code to checkout this tree and select the proper branch 
> in this tree.
> 
> 
> Basically, you do
> 
> git clone --reference XXXX git://git.infradead.org/libertas-2.6
> cd libertas-2.6
> git branch libertas-cf
> git checkout libertas-cf
> git pull origin libertas
> 
> 
> 
> However, I've "Signed-Up" this driver and asked Dan to forward it 
> into wireless-dev. He hasn't done this yet :-(

I'm sending Linville a pull request for current 'libertas' branch of
libertas-2.6 today; is that what you mean?

Dan

> 
> If anyone want's to review the patch (in addition to what people 
> did on the libertas-dev mailing list), here's an URL:
> 
> http://git.infradead.org/?p=libertas-2.6.git;a=commitdiff;h=9e25bb4c6ed9430e166b69f9f91bfccd96f0869d
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

