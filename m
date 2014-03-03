Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa11-09.prod.phx3.secureserver.net ([68.178.252.110]:56621
	"EHLO p3plsmtpa11-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbaCCSLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 13:11:14 -0500
Date: Mon, 3 Mar 2014 11:11:12 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Felipe Balbi <balbi@ti.com>, Erick Macias <emacias@ti.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] NFC: trf7970a: Add driver with ISO/IEC 14443 Type
 2 Tag Support
Message-ID: <20140303181112.GA32605@animalcreek.com> (sfid-20140303_191118_684342_D64192E2)
References: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
 <1391206631-9862-2-git-send-email-mgreer@animalcreek.com>
 <20140221005059.GS18868@zurbaran>
 <20140226215309.GA21867@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140226215309.GA21867@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 26, 2014 at 02:53:09PM -0700, Mark A. Greer wrote:
> On Fri, Feb 21, 2014 at 01:50:59AM +0100, Samuel Ortiz wrote:
> > Hi Mark,
> 
> Hi Samuel - thanks for the feedback.
> 
> > Code looks quite nice, especially since this looks like a fairly complex
> > driver. And the initial coments are quite useful, I appreciate that.
> > I have a few comments/questions though:
> > 
> > 
> > > + * been received and there isn't an error).  The delay is 3 ms since delays
> > > + * over 2 ms have been observed during testing.
> > Would you say this timeout depend on the SPI bus bandwidth ?
> 
> It'll be one of the factors but the tag's response characteristics are
> a big factor too.  I can bump it up a bit more if you prefer or do you
> want me to somehow calculate it from the SPI bitrate?

Ping.
