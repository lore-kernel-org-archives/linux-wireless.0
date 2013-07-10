Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from happy.seestieto.com ([176.58.110.22]:54618 "EHLO
	happy.seestieto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab3GJIXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 04:23:21 -0400
Date: Wed, 10 Jul 2013 10:49:30 +0300
From: Henrik Ahlgren <pablo@seestieto.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"debian-backports@lists.debian.org"
	<debian-backports@lists.debian.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sergey Frolov <dunkan.aidaho@gmail.com>
Subject: Re: [Ilw] Re: Performance regression in firmware-iwlwifi 0.38~bpo70+1
Message-ID: <20130710074930.GE11186@seestieto.com> (sfid-20130710_102328_676738_A2CBD3FD)
References: <20130709153104.20718ebb@thinkpad>
 <1373425655.24446.7.camel@deadeye.wl.decadent.org.uk>
 <0BA3FCBA62E2DC44AF3030971E174FB3019FFDBF@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB3019FFDBF@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 10, 2013 at 05:32:21AM +0000, Grumbach, Emmanuel wrote:

> Just to make sure I properly understand what you are saying here: only the firmware is changed? Not the driver?

BTW, in my Thinkpad x21e (Intel Wireless-N 1000) I've noticed a very
high (~80%+) CPU utilization by the "irq/42-iwlwifi" kernel process
with the 3.9.x series kernel (self-built from upstream GIT sources)
and 3.10. Not sure in what exact 3.9 version this behaviour
started. I'm using the standard 0.36+wheezy.1 (non-free) version of
firmware-iwlwifi.
