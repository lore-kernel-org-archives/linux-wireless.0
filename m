Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17287 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbaCCUhP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 15:37:15 -0500
Date: Mon, 3 Mar 2014 21:37:07 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Mark A. Greer" <mgreer@animalcreek.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Felipe Balbi <balbi@ti.com>, Erick Macias <emacias@ti.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] NFC: trf7970a: Add driver with ISO/IEC 14443 Type 2
 Tag Support
Message-ID: <20140303203707.GB17664@zurbaran> (sfid-20140303_213725_717250_40864139)
References: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
 <1391206631-9862-2-git-send-email-mgreer@animalcreek.com>
 <20140221005059.GS18868@zurbaran>
 <20140226215309.GA21867@animalcreek.com>
 <20140303181112.GA32605@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140303181112.GA32605@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mark,

On Mon, Mar 03, 2014 at 11:11:12AM -0700, Mark A. Greer wrote:
> > > Would you say this timeout depend on the SPI bus bandwidth ?
> > 
> > It'll be one of the factors but the tag's response characteristics are
> > a big factor too.  I can bump it up a bit more if you prefer or do you
> > want me to somehow calculate it from the SPI bitrate?
> 
> Ping.
Sorry, I missed that one: No, bumping it a bit more just to be on the
safe side will be enough.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
