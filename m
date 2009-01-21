Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway15.websitewelcome.com ([67.18.94.13]:40858 "HELO
	gateway15.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751433AbZAUQyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 11:54:10 -0500
Received: from 96-26-216-101.sea.clearwire-dns.net ([96.26.216.101]:54231 helo=Hydra.darkmatter.org)
	by solstice.websitewelcome.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <Info@delphi-real-estate.com>)
	id 1LPfvN-0005kE-2V
	for linux-wireless@vger.kernel.org; Wed, 21 Jan 2009 10:27:29 -0600
From: Delphi Real Estate <Info@delphi-real-estate.com>
To: linux-wireless@vger.kernel.org
Subject: Re: Kernel Compile Fail with 2.6.26 Drivers
Date: Wed, 21 Jan 2009 08:27:27 -0800
References: <200901200942.57618.Info@delphi-real-estate.com>
In-Reply-To: <200901200942.57618.Info@delphi-real-estate.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901210827.27677.Info@delphi-real-estate.com> (sfid-20090121_175416_294752_AF3C755E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Has anyone got 'n' working in iwlwifi at 5GHz and kernel =>2.6.27?  If so, can you please tell me how?


On Tuesday 20 January 2009 9:42:57 you wrote:
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


