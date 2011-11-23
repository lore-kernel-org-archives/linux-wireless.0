Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab1KWPmH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:42:07 -0500
Date: Wed, 23 Nov 2011 16:44:38 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Amir Hedayaty <hedayaty@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
Message-ID: <20111123154437.GC13460@redhat.com> (sfid-20111123_164211_664857_C622168D)
References: <20111116100915.GA2191@redhat.com>
 <20111122214940.GH8452@tuxdriver.com>
 <20111123080506.GB9833@redhat.com>
 <CAGXE3d-HE8MWV5Xv9e407iDn83UFvjua52mYGEJuJnQuQvnyog@mail.gmail.com>
 <20111123105106.GA7943@redhat.com>
 <CAN6fvj2=EhimZUy-DKtpzAKq1mpvBt03KtX9vCi0dBTCXWVsRg@mail.gmail.com>
 <20111123151414.GC7943@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111123151414.GC7943@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 23, 2011 at 04:14:14PM +0100, Stanislaw Gruszka wrote:
> > ohci_hcd:usb3, ohci_hcd:usb4, snd_hda_intel
> >  17:   22153190     140306   13063918   91518105   IO-APIC-fasteoi
> > ehci_hcd:usb1, 0000:02:00.0
[snip]
> I'm seeing rt2800pci anywhere, is module loaded?
It must be 0000:02:00.0 entry, lscpi can be used to confirm that.
  
Stanislaw
