Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32797 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbaBUBEd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 20:04:33 -0500
Date: Fri, 21 Feb 2014 02:04:07 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Mark A. Greer" <mgreer@animalcreek.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Felipe Balbi <balbi@ti.com>, Erick Macias <emacias@ti.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] NFC: trf7970a: Add DTS Documentation
Message-ID: <20140221010407.GU18868@zurbaran> (sfid-20140221_020441_920188_FA0CAC85)
References: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
 <1391206631-9862-4-git-send-email-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391206631-9862-4-git-send-email-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mark,

On Fri, Jan 31, 2014 at 03:17:11PM -0700, Mark A. Greer wrote:
> Describe the properies used by the trf7970a
> RFID/NFC/15693 transceiver driver.
> 
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> ---
>  .../devicetree/bindings/net/nfc/trf7970a.txt       | 37 ++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/trf7970a.txt
Not a DT expert, but this looks good to me.
Could you please amend this patch by adding
Documentation/devicetree/bindings/net/nfc/ to the MAINTAINERS NFC
section ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
