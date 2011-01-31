Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab1AaJqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 04:46:32 -0500
Date: Mon, 31 Jan 2011 10:46:25 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/8] iwlagn: remove
 CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
Message-ID: <20110131094624.GA20641@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
 <1296229671-3041-7-git-send-email-sgruszka@redhat.com>
 <1296231817.7388.18.camel@wwguy-ubuntu>
 <20110128164136.GF2452@redhat.com>
 <1296256821.8832.1.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296256821.8832.1.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 28, 2011 at 03:20:21PM -0800, wwguy wrote:
> > What is easiest and less time consuming:
> > 
> > this:
> > 
> > $ mv /lib/firmware/iwlwifi-5000-exp.ucode /lib/firmware/iwlwifi-5000-exp.ucode.not_use
> > 
> > or this:
> > 
> > $ make menuconfig
> > navigate to find option and edit it 
> > $ make modules
> > $ make modules_install
> > 
> > ?
> > 
> > > Also put it in Kconfig file, so it is easy for user to see they are
> > > using experimental option. Agree?
> > 
> > Not really. I believe someone who download a tarball, unpack it and copy
> > files to /lib/firmware is pretty much aware what he/she is doing.
> > 
> Agree whoever download the tarball know what he/she is doing, but I am
> not fully agree the driver always use experimental uCode if it is in the
> firmware directory

I do not understand what for you need that, but ok, I can live with it.

John, please skip this patch.

Stanislaw
