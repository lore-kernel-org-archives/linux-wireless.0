Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway05.websitewelcome.com ([64.5.38.5]:41229 "HELO
	gateway05.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753716AbZAXCRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 21:17:13 -0500
Received: from 96-26-216-101.sea.clearwire-dns.net ([96.26.216.101]:41569 helo=Hydra.darkmatter.org)
	by solstice.websitewelcome.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <Info@delphi-real-estate.com>)
	id 1LQXyj-000185-UF
	for linux-wireless@vger.kernel.org; Fri, 23 Jan 2009 20:10:34 -0600
From: Delphi Real Estate <Info@delphi-real-estate.com>
To: linux-wireless@vger.kernel.org
Subject: Re: Kernel Compile Fail with 2.6.26 Drivers
Date: Fri, 23 Jan 2009 18:10:31 -0800
References: <200901200942.57618.Info@delphi-real-estate.com> <200901230550.25986.Info@delphi-real-estate.com> <1232729629.4501.37.camel@rc-desk>
In-Reply-To: <1232729629.4501.37.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901231810.31206.Info@delphi-real-estate.com> (sfid-20090124_031721_595138_381B066C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Haven't lost track of what we've discussed.  

I am unable to make the iwlwifi branch compile in kernel 2.6.27 or .28 with Ubuntu patches.  It simply will not compile.  I am just looking for a way to make this work.

With the iwlwifi driver that comes with kernel Ubuntu 2.6.27.10 I can not associate in 'n' at 5.2GHz with the 4965AGN and DLink DIR-825.  Will not associate.  But does in 'a' and works fairly well. 


On Friday 23 January 2009 8:53:49 you wrote:
> On Fri, 2009-01-23 at 05:50 -0800, Delphi Real Estate wrote:
> > It seems that either no one has 'n' working at 5GHz, or are not willing to advise.  All I need is a combination that works;  I've tried 2.6's iwlwifi in 2.6.27 and it won't compile, and it seems that 2.6.28's iwlwifi doesn't work in 'n'.  I've run Debian for eleven years and have always compiled my own custom kernels, but would very much like to get 'n' working.  Scripting is no problem, although I am not an actual coder.  I wish someone could pitch in briefly.
> 
> As a summary of our discussion so far:
> 
> 80211n currently works, except that you will get slower speeds because
> TX aggregation is not working.
> 
> If you want TX aggregation support then you can use the iwl5000 branch
> of the iwlwifi-2.6 repo on git.kernel.org, which is based on kernel
> 2.6.26.
> 
> We are working on getting TX aggregation working again.
> 
> Reinette

