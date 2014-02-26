Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa11-09.prod.phx3.secureserver.net ([68.178.252.110]:37642
	"EHLO p3plsmtpa11-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809AbaBZV6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 16:58:40 -0500
Date: Wed, 26 Feb 2014 14:54:14 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Felipe Balbi <balbi@ti.com>, Erick Macias <emacias@ti.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] NFC: trf7970a: Add DTS Documentation
Message-ID: <20140226215414.GC21867@animalcreek.com> (sfid-20140226_225850_024894_5114B646)
References: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
 <1391206631-9862-4-git-send-email-mgreer@animalcreek.com>
 <20140221010407.GU18868@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140221010407.GU18868@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 21, 2014 at 02:04:07AM +0100, Samuel Ortiz wrote:
> Hi Mark,
> 
> On Fri, Jan 31, 2014 at 03:17:11PM -0700, Mark A. Greer wrote:
> > Describe the properies used by the trf7970a
> > RFID/NFC/15693 transceiver driver.
> > 
> > Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> > ---
> >  .../devicetree/bindings/net/nfc/trf7970a.txt       | 37 ++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/nfc/trf7970a.txt
> Not a DT expert, but this looks good to me.
> Could you please amend this patch by adding
> Documentation/devicetree/bindings/net/nfc/ to the MAINTAINERS NFC
> section ?

Sure.
