Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54753 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab1HaNpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 09:45:23 -0400
Date: Wed, 31 Aug 2011 09:38:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dennis Nezic <dennisn@dennisn.dyndns.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ipw2200 antenna selection
Message-ID: <20110831133838.GA2474@tuxdriver.com> (sfid-20110831_154555_342260_C2B1AB72)
References: <20110830215135.db381ecf.dennisn@dennisn.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110830215135.db381ecf.dennisn@dennisn.dyndns.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 09:51:35PM -0400, Dennis Nezic wrote:
> My ipw2200 pcie wifi card has 2 antennas... "Main" and "Aux". I think
> either the firmware or the kernel/module is overriding my explicit
> antenna module setting, after a while.
> 
> I mentioned about it a few days ago,
> http://marc.info/?l=linux-wireless&m=131448481319374&w=2
> although I'm still seeing the problem (even after physically
> disconnecting the Aux antenna/wire. (Even after disconnecting it, I
> think it is still able to receive the 30KB/s signal, and I think the
> card still switches to it eventually, against my wishes.))

Dennis,

I'm sorry you haven't received any replies until now.  The truth
is that the ipw2200 hardware is a bit old, and has more-or-less
been abandoned by the manufacturer and the original driver authors.
Worse, no hardware specification is available and even if it were
then likely no firmware changes would be possible.

You mentioned that one of your antenna lines is cut.  Is it possible
that you might repair that antenna?

Would it be possible for you to try using a much older kernel?
If you can find a point where the problem you are seeing does not
exist, then we may be able to pinpoint a change that is contributing
to the issue you are seeing.  Beyond that, I'm not sure what else we
might do to help.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
