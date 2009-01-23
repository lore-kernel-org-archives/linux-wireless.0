Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway14.websitewelcome.com ([67.18.44.10]:52385 "HELO
	gateway14.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756084AbZAWN5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 08:57:08 -0500
Received: from 96-26-216-101.sea.clearwire-dns.net ([96.26.216.101]:44531 helo=Hydra.darkmatter.org)
	by solstice.websitewelcome.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <Info@delphi-real-estate.com>)
	id 1LQMQU-0005Wc-GH
	for linux-wireless@vger.kernel.org; Fri, 23 Jan 2009 07:50:27 -0600
From: Delphi Real Estate <Info@delphi-real-estate.com>
To: linux-wireless@vger.kernel.org
Subject: Re: Kernel Compile Fail with 2.6.26 Drivers
Date: Fri, 23 Jan 2009 05:50:25 -0800
References: <200901200942.57618.Info@delphi-real-estate.com>
In-Reply-To: <200901200942.57618.Info@delphi-real-estate.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901230550.25986.Info@delphi-real-estate.com> (sfid-20090123_145718_265923_0A72BAC7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


It seems that either no one has 'n' working at 5GHz, or are not willing to advise.  All I need is a combination that works;  I've tried 2.6's iwlwifi in 2.6.27 and it won't compile, and it seems that 2.6.28's iwlwifi doesn't work in 'n'.  I've run Debian for eleven years and have always compiled my own custom kernels, but would very much like to get 'n' working.  Scripting is no problem, although I am not an actual coder.  I wish someone could pitch in briefly.



On Tuesday 20 January 2009 9:42:57 Delphi Real Estate wrote:
> 
> Trying to get 5GHz 'n' working, but I just do not understand the advice I'm getting. (below)  I am told that TX aggregation support is not expected to be fixed until around 2.6.30.
> 
> Goal is to be able to get some version of the iwlagn drivers that will do 'n' mode at 5GHz, which will compile in my Ubuntu 2.6.27 kernel.  I tried just grafting in the 2.6.26 iwlwifi directory into my 2.6.27 source tree, but compile fails without explanation.
> 
> Can anyone help?
> 
> 
> > If you want the driver with TX aggregation support then you need to use
> > the iwl5000 branch
> > ( http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=shortlog;h=iwl5000 )
> 
> I guess I don't understand this.  I hit the first entry's 'snapshot', and I get a blank screen.  I click on the heading:
> "iwlwifi: fix incorrect monitor mode operation  iwl5000"
> ... and it takes me to the explanation of the bugfix, but navigating to iwl-agn.c or iwl3945-base.c via tree, snapshot or blob just gives me an HTML representation of the files.  There doesn't seem to be any way to get the actual source.  Why do they prevent you from getting just individual files with this system?
> 
> 
> > The branch is based on kernel 2.6.26. If you do not want to give up your
> > current kernel you can take a look how compat-wireless works ... but it
> > is actually intended to take the most recent wireless-testing to work
> > with your current kernel, not an older kernel in itself as what can be
> > found in the iwl5000 branch.
> 
> I don't mind running the most recent kernel, as long as it works and has Ubuntu patches.  I don't see how to get there from here though.  I am a commercial real estate broker, after all, not a coder.
> 
> 
> > Try diffing the Ubuntu sources against the kernel.org sources, and
> > merge the resulting diff into the git tree.
> 
> LOL, thanks, but I am a commercial real estate broker, and have about as much chance of doing this as passing a calculus class.
> 
> Just trying to get 'n' at 5GHz, so I don't pollute my neighbors' wifi with my MythTV streaming.  I am lucky to have working what I do...
> 
> 


