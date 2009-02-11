Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39617 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbZBKQay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 11:30:54 -0500
Date: Wed, 11 Feb 2009 11:25:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH 0/3] iwlwifi driver updates 02/10/2009
Message-ID: <20090211162549.GA5082@tuxdriver.com> (sfid-20090211_173058_445115_4E67458D)
References: <1234307944-21820-1-git-send-email-reinette.chatre@intel.com> <1234368987.23593.35.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1234368987.23593.35.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 11, 2009 at 08:16:27AM -0800, reinette chatre wrote:
> On Tue, 2009-02-10 at 15:19 -0800, Chatre, Reinette wrote:
> > Two cleanups and a fix to configure 5000 series FAT channels correctly.
> > 
> > [PATCH 1/3] iwlwifi: use pci registers defined in pci_regs.h
> > [PATCH 2/3] iwlwifi: drop PCIe workaround applicable for development boards
> > [PATCH 3/3] iwlwifi: fix FAT channel config for 5000 series
> 
> John,
> 
> Two of these patches have a duplicate "From:" line that will cause
> git-am to include this information in the commit message.
> 
> Should I resend?
> 
> Reinette

I've fixed that already, thanks. :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
