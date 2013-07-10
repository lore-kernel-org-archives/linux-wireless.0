Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab3GJHyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 03:54:25 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Henrik Ahlgren <pablo@seestieto.com>
CC: Ben Hutchings <ben@decadent.org.uk>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"debian-backports@lists.debian.org"
	<debian-backports@lists.debian.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sergey Frolov <dunkan.aidaho@gmail.com>
Subject: RE: [Ilw] Re: Performance regression in firmware-iwlwifi
 0.38~bpo70+1
Date: Wed, 10 Jul 2013 07:53:57 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301A000F7@HASMSX103.ger.corp.intel.com> (sfid-20130710_095428_801703_C9F75CC9)
References: <20130709153104.20718ebb@thinkpad>
 <1373425655.24446.7.camel@deadeye.wl.decadent.org.uk>
 <0BA3FCBA62E2DC44AF3030971E174FB3019FFDBF@HASMSX103.ger.corp.intel.com>
 <20130710074930.GE11186@seestieto.com>
In-Reply-To: <20130710074930.GE11186@seestieto.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Just to make sure I properly understand what you are saying here: only the
> firmware is changed? Not the driver?
> 
> BTW, in my Thinkpad x21e (Intel Wireless-N 1000) I've noticed a very
> high (~80%+) CPU utilization by the "irq/42-iwlwifi" kernel process
> with the 3.9.x series kernel (self-built from upstream GIT sources)
> and 3.10. Not sure in what exact 3.9 version this behaviour
> started. I'm using the standard 0.36+wheezy.1 (non-free) version of
> firmware-iwlwifi.

For CPU utilization:
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi.git/commit/?id=01911dab97cb3e21e640aaca82689acec00ed848
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi.git/commit/?id=68972c46f2975d3d61f9dc9f311f77bfc8a8b12b


