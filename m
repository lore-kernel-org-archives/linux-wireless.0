Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbbEDGzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 02:55:08 -0400
Date: Mon, 4 May 2015 08:55:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
cc: "piotr.karbowski@gmail.com" <piotr.karbowski@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi getting stuck with current Linus' tree (646da63172)
In-Reply-To: <1430713926.3388.1.camel@intel.com>
Message-ID: <alpine.LNX.2.00.1505040853590.17496@pobox.suse.cz> (sfid-20150504_085517_032877_B0EDF92D)
References: <alpine.LNX.2.00.1504222235340.3695@pobox.suse.cz>   <1429764440.4084.5.camel@intel.com>   <alpine.LNX.2.00.1504231011500.3695@pobox.suse.cz>   <1429780366.11859.1.camel@intel.com>   <alpine.LNX.2.00.1504231114290.3695@pobox.suse.cz>  
 <CA+uBNfxXoLj9Nfss+j1G3PY9A2t=N6KRiYUAdoxiUOZvigwyAw@mail.gmail.com>  <1429812611.23202.4.camel@intel.com>  <alpine.LNX.2.00.1505032340090.17496@pobox.suse.cz> <1430713926.3388.1.camel@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 4 May 2015, Grumbach, Emmanuel wrote:

> > so over a past few days, I tried to perform a bisect, but failed as 
> > expected. The issue is not reliably enough reproducible for me, so I ended 
> > up with a completely bogus commit.
> > 
> > *However*, now that I have been following the causes and symptoms more 
> > closely (due to the bisect attempt), I have to confirm that the issue 
> > happens much more often when the machine is question is physically being 
> > moved when associated.
> > 
> 
> I am doing this all the time and I don't hit your problem. Without any
> logs I don't see how I can help here. Please try to catch logs of the
> crash. Thanks.

I have provided them in the very first e-mail to this thread; see

	https://lkml.org/lkml/2015/4/22/601

If there is any way how to obtain more verbose / useful logs, please let 
me know, I'll be happy to do that.

-- 
Jiri Kosina
SUSE Labs
