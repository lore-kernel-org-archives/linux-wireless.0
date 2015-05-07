Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbbEGIyy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 04:54:54 -0400
Date: Thu, 7 May 2015 10:54:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
cc: "piotr.karbowski@gmail.com" <piotr.karbowski@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi getting stuck with current Linus' tree (646da63172)
In-Reply-To: <1430722924.26162.4.camel@intel.com>
Message-ID: <alpine.LNX.2.00.1505071052290.8186@pobox.suse.cz> (sfid-20150507_105459_554483_E3647A90)
References: <alpine.LNX.2.00.1504222235340.3695@pobox.suse.cz>    <1429764440.4084.5.camel@intel.com>    <alpine.LNX.2.00.1504231011500.3695@pobox.suse.cz>    <1429780366.11859.1.camel@intel.com>    <alpine.LNX.2.00.1504231114290.3695@pobox.suse.cz>   
 <CA+uBNfxXoLj9Nfss+j1G3PY9A2t=N6KRiYUAdoxiUOZvigwyAw@mail.gmail.com>   <1429812611.23202.4.camel@intel.com>   <alpine.LNX.2.00.1505032340090.17496@pobox.suse.cz>  <1430713926.3388.1.camel@intel.com>  <alpine.LNX.2.00.1505040853590.17496@pobox.suse.cz>
 <1430722924.26162.4.camel@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 4 May 2015, Grumbach, Emmanuel wrote:

> Sorry, my bad. I lost context here... So I really don't know what to 
> say. I can't see any iwlwifi commit that could be causing this, OTOH, 
> bisection didn't bring any results. You can try to unregister the device 
> from PCI and then to rescan. It worked for some people. Other than that, 
> I can't do much. Did you update your BIOS before you started to see this 
> failure?

Well, this kept getting worse and worse. Newer kernels were much "better" 
provoking the HW crashes, but a few days ago I started seeing it even with 
very old kernels, which used to be rock stable.

I first ruled out a firmware update to be the cause.

So I dismanlted the notebook and replaced the wifi chip with another one 
(also driven by iwlwifi), and no failure after 2 days so far.

So it might turn out that this particular one was a red herring. If it 
happens again even with the replaced chip, I'll report back. Sorry for the 
noise.

-- 
Jiri Kosina
SUSE Labs
