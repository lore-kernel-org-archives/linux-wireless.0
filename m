Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15649 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab0AVBhy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 20:37:54 -0500
Subject: Re: Intel 4965 HT rates
From: Zhu Yi <yi.zhu@intel.com>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Valentin Manea <linux-wireless@mrs.ro>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c911001211309h34883daewd557b574a456d359@mail.gmail.com>
References: <E9954878DD1FB34FAE5187FB88C58A357683393C@orsmsx506.amr.corp.intel.com>
	 <1261363447.12157.624.camel@debian>
	 <69e28c910912210552p1f63a47dw9fbabf2c26ce02e9@mail.gmail.com>
	 <1264058284.5089.13.camel@debian>
	 <69e28c911001211309h34883daewd557b574a456d359@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 09:37:49 +0800
Message-ID: <1264124269.4219.23.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-01-21 at 13:09 -0800, Gábor Stefanik wrote:
> > Can you dump your 4965 eeprom and see if the channels in band 6
> (2.4GHz
> > 40MHz channel band) are valid? You can use modparam "debug=1" and
> grep
> > 'HT40' in dmesg. If the flag is 0x0, the channel is marked as
> invalid by
> > EEPROM. The Linux driver simply excludes the HT40 channel in this
> case.
>
> Unfortunately I have exchanged my 4965 for an 5300 (it failed
> recently, and a 5300 was the replacement), so I can no longer provide
> a dump. However, others can probably produce one, and if needed, I can
> buy another 4965 to see if it still does 2.4GHz HT40 in Windos. 

No problem. All my 4965 cards here have empty band 6 channels. I just
wonder if yours is different. If so, it is a quirk the Windows driver
enables 2.4GHz HT40 channels (for some cases) ignoring the EEPROM
setting. As the firmware for Linux driver has strong regulatory
checking, this might be impossible without changing the firmware.

Thanks,
-yi

