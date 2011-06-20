Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62383 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab1FTTKp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 15:10:45 -0400
Subject: Re: [3.0 regression] DMAR faults in iwlagn
From: wwguy <wey-yi.w.guy@intel.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com>
References: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 12:06:57 -0700
Message-ID: <1308596817.21011.8.camel@wwguy-ubuntu> (sfid-20110620_211050_882209_1C0EFCBA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-20 at 11:44 -0700, Andrew Lutomirski wrote:
> On 3.0-git today, I get:
> 
> [   40.142872] DRHD: handling fault status reg 2
> [   40.142892] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe38000
> [   40.142896] DMAR:[fault reason 05] PTE Write access is not set
> 
> lspci says:
> 
> 03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 35)
> 
> This seems to be triggered by interface state changes.  The driver
> still works.  I don't see this on 2.6.39.1.
> 
can I got more information. which repo you are using?
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

Can you provide full log?

Thanks
Wey

