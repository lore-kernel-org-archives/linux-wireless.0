Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38839 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1AaO64 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 09:58:56 -0500
Subject: Re: [PATCH 7/8] iwlagn: remove
 CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
From: wwguy <wey-yi.w.guy@intel.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTinBneG0nqGFt=mnP0-ZSdLGzdxhfYpyo62WYJQA@mail.gmail.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
	 <1296229671-3041-7-git-send-email-sgruszka@redhat.com>
	 <1296231817.7388.18.camel@wwguy-ubuntu>	<20110128164136.GF2452@redhat.com>
	 <1296256821.8832.1.camel@wwguy-ubuntu>	<20110131094624.GA20641@redhat.com>
	 <AANLkTinBneG0nqGFt=mnP0-ZSdLGzdxhfYpyo62WYJQA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 06:57:20 -0800
Message-ID: <1296485840.10026.4.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw,

On Mon, 2011-01-31 at 02:23 -0800, Rafał Miłecki wrote:
> 2011/1/31 Stanislaw Gruszka <sgruszka@redhat.com>:
> > On Fri, Jan 28, 2011 at 03:20:21PM -0800, wwguy wrote:
> >> > What is easiest and less time consuming:
> >> >
> >> > this:
> >> >
> >> > $ mv /lib/firmware/iwlwifi-5000-exp.ucode /lib/firmware/iwlwifi-5000-exp.ucode.not_use
> >> >
> >> > or this:
> >> >
> >> > $ make menuconfig
> >> > navigate to find option and edit it
> >> > $ make modules
> >> > $ make modules_install
> >> >
> >> > ?
> >> >
> >> > > Also put it in Kconfig file, so it is easy for user to see they are
> >> > > using experimental option. Agree?
> >> >
> >> > Not really. I believe someone who download a tarball, unpack it and copy
> >> > files to /lib/firmware is pretty much aware what he/she is doing.
> >> >
> >> Agree whoever download the tarball know what he/she is doing, but I am
> >> not fully agree the driver always use experimental uCode if it is in the
> >> firmware directory
> >
> > I do not understand what for you need that, but ok, I can live with it.
> >
> > John, please skip this patch.
> 
> Maybe make it module parameter? Like use_experimental_fw, default to 0?
> 
I think module parameter is better idea, if you agree, and I will ack

Thanks
Wey

