Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:22447 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYJ1Aqm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 20:46:42 -0400
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
From: reinette chatre <reinette.chatre@intel.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081027230326.GA23250@isilmar.linta.de>
References: <20081018231046.GA10977@isilmar.linta.de>
	 <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com>
	 <20081019075916.GA12904@isilmar.linta.de>
	 <1225145468.1115.139.camel@rc-desk>
	 <20081027230326.GA23250@isilmar.linta.de>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 17:47:03 -0700
Message-Id: <1225154823.1115.149.camel@rc-desk> (sfid-20081028_014646_540786_3F9EDC06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-27 at 16:03 -0700, Dominik Brodowski wrote:
> Hi,
> 
> On Mon, Oct 27, 2008 at 03:11:08PM -0700, reinette chatre wrote:
> > Could you please try the following patch instead of updating your ucode?
> 
> Thanks for the patch -- it doesn't work with the old uCode, unfortunately;
> while the new uCode works with or without this patch.
> 

We would like to trace what is causing that microcode error - could you
please reproduce the problem while debugging is enabled in the driver?
That will give us a full log of the microcode error. Please compile your
driver with debugging (CONFIG_IWL3945_DEBUG) and load the module with
option "debug=0x43fff". Please run the test without the patch I just
sent.

Thank you very much

Reinette


