Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.133.102.198]:37243 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750719AbYJSH7T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 03:59:19 -0400
Date: Sun, 19 Oct 2008 09:59:16 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
Message-ID: <20081019075916.GA12904@isilmar.linta.de> (sfid-20081019_095946_890304_F65EC16D)
References: <20081018231046.GA10977@isilmar.linta.de> <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 19, 2008 at 01:30:50AM +0200, Tomas Winkler wrote:
> On Sun, Oct 19, 2008 at 1:10 AM, Dominik Brodowski
> > [   37.340901] iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> > [   37.340944] iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq 0x4413 ser 0x0000004B
> > [   37.342349] iwl3945: Can't stop Rx DMA.
> >
> > The iwlwifi-3945-1.ucode is the one shipped with Ubuntu's 2.6.24-21-generic
> > kernel sources (md5sum: 26d10014b09439dc5a8573c2a6f85b0a ). And, as
> > mentioned in the subject, 2.6.27 or 2.6.26 work perfectly fine.
> 
> I think you need new uCode, the API has changed to support stealth APs
> .... I believe there was some misscommunication...

Thanks for the hint -- indeed, the newest uCode works both with 2.6.26 and
current git... so the uCode is backwards compatible, but the kernel code is
not. Should the uCode be named iwlwifi-3945-2.ucode therefore, to notify the
users that they need something newer? Or can the kernel code be made to work
with the old uCode again?

Thanks,
	Dominik
