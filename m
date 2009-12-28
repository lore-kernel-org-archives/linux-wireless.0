Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51195 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbZL1Dpo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Dec 2009 22:45:44 -0500
Subject: Re: Intel 4965 HT rates
From: Zhu Yi <yi.zhu@intel.com>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Valentin Manea <linux-wireless@mrs.ro>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910912210552p1f63a47dw9fbabf2c26ce02e9@mail.gmail.com>
References: <E9954878DD1FB34FAE5187FB88C58A357683393C@orsmsx506.amr.corp.intel.com>
	 <1261363447.12157.624.camel@debian>
	 <69e28c910912210552p1f63a47dw9fbabf2c26ce02e9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 11:45:42 +0800
Message-ID: <1261971942.6037.57.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-12-21 at 21:52 +0800, Gábor Stefanik wrote:
> On Mon, Dec 21, 2009 at 3:44 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> > On Mon, 2009-12-21 at 10:33 +0800, Guy, Wey-Yi W wrote:
> >> For 4965, 40MHz only supported in g band
> >
> > We don't support 40MHz channels in 2.4G band. See comments in
> > iwl-eeprom.h:
> >
> >  *
> >  * NOTE:  4965 does not support HT40 channels on 2.4 GHz.
> >  */
> >
> > Thanks,
> > -yi
> 
> But why does the Windows driver for 4965 support it then? 

Have you tested how well it is supported? The firmware people suggest to
disable this feature (although the hardware was originally designed to)
due to some internal problems.

Thanks,
-yi

