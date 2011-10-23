Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:5102 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab1JWV0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 17:26:31 -0400
Received: from hpaq2.eem.corp.google.com (hpaq2.eem.corp.google.com [172.25.149.2])
	by smtp-out.google.com with ESMTP id p9NLQS0p022792
	for <linux-wireless@vger.kernel.org>; Sun, 23 Oct 2011 14:26:28 -0700
Received: from pzk4 (pzk4.prod.google.com [10.243.19.132])
	by hpaq2.eem.corp.google.com with ESMTP id p9NLQ7T0016307
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 23 Oct 2011 14:26:27 -0700
Received: by pzk4 with SMTP id 4so19503860pzk.10
        for <linux-wireless@vger.kernel.org>; Sun, 23 Oct 2011 14:26:27 -0700 (PDT)
Date: Sun, 23 Oct 2011 14:26:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Norbert Preining <preining@logic.at>
cc: wwguy <wey-yi.w.guy@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
In-Reply-To: <20111021012442.GB26758@gamma.logic.tuwien.ac.at>
Message-ID: <alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com> (sfid-20111023_232645_570336_E5CB801A)
References: <20111019124931.GC3963@gamma.logic.tuwien.ac.at> <1319038282.25023.21.camel@wwguy-ubuntu> <20111019060108.GA11588@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com> <20111019062517.GC11588@gamma.logic.tuwien.ac.at>
 <1319003304.31823.46.camel@wwguy-huron> <20111019064628.GA14817@gamma.logic.tuwien.ac.at> <1319004836.31823.57.camel@wwguy-huron> <20111020045927.GB23044@gamma.logic.tuwien.ac.at> <1319119852.2111.2.camel@wwguy-ubuntu>
 <20111021012442.GB26758@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 21 Oct 2011, Norbert Preining wrote:

> > Great, this is just a test patch, we will figure out what is the correct
> > way to handle this and fix the issue for good :-)
> 
> Thanks. If you need more testing just let me know.
> 

It'd be interesting to see if this problem still exists in linux-next 
since some wireless changes went into that recently.  Please try the tree 
at git://github.com/sfrothwell/linux-next.git
