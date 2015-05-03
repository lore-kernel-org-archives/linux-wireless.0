Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbbECVmQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 17:42:16 -0400
Date: Sun, 3 May 2015 23:42:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
cc: "piotr.karbowski@gmail.com" <piotr.karbowski@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi getting stuck with current Linus' tree (646da63172)
In-Reply-To: <1429812611.23202.4.camel@intel.com>
Message-ID: <alpine.LNX.2.00.1505032340090.17496@pobox.suse.cz> (sfid-20150503_234221_529485_E3874767)
References: <alpine.LNX.2.00.1504222235340.3695@pobox.suse.cz>  <1429764440.4084.5.camel@intel.com>  <alpine.LNX.2.00.1504231011500.3695@pobox.suse.cz>  <1429780366.11859.1.camel@intel.com>  <alpine.LNX.2.00.1504231114290.3695@pobox.suse.cz>
 <CA+uBNfxXoLj9Nfss+j1G3PY9A2t=N6KRiYUAdoxiUOZvigwyAw@mail.gmail.com> <1429812611.23202.4.camel@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

so over a past few days, I tried to perform a bisect, but failed as 
expected. The issue is not reliably enough reproducible for me, so I ended 
up with a completely bogus commit.

*However*, now that I have been following the causes and symptoms more 
closely (due to the bisect attempt), I have to confirm that the issue 
happens much more often when the machine is question is physically being 
moved when associated.

-- 
Jiri Kosina
SUSE Labs
