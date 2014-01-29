Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaA2N5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 08:57:43 -0500
Date: Wed, 29 Jan 2014 14:59:06 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Brian King <brking@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wil6210@qca.qualcomm.com, ath10k@lists.infradead.org,
	linux-nvme@lists.infradead.org,
	"linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 0/9] Phase out pci_enable_msi_block()
Message-ID: <20140129135906.GA3495@dhcp-26-207.brq.redhat.com> (sfid-20140129_145840_616502_252EF94A)
References: <cover.1389904166.git.agordeev@redhat.com>
 <CAErSpo5ztnyyceeN38XzLasLV6eJqdbqEV0viPp3Af8U=ts23w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAErSpo5ztnyyceeN38XzLasLV6eJqdbqEV0viPp3Af8U=ts23w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 17, 2014 at 02:00:32PM -0700, Bjorn Helgaas wrote:
> > Bjorn,
> >
> > As the release is supposedly this weekend, do you prefer
> > the patches to go to your tree or to individual trees after
> > the release?
> 
> I'd be happy to merge them, except for the fact that they probably
> wouldn't have any time in -next before I ask Linus to pull them.  So
> how about if we wait until after the release, ask the area maintainers
> to take them, and if they don't take them, I'll put them in my tree
> for v3.15?

Hi Gentleman,

As the prerequisite commit 302a252 ("PCI/MSI: Add pci_enable_msi_range()
and pci_enable_msix_range()") is in mainline now, could you please take
the ACKed patches to your trees?

Thanks!

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
