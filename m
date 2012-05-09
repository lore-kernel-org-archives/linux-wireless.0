Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760733Ab2EISdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 14:33:35 -0400
Message-ID: <1336588414.1121.5.camel@jlt3.sipsolutions.net> (sfid-20120509_203339_302492_C7590BE8)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: Kevin Groeneveld <kgroeneveld@gmail.com>,
	Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 09 May 2012 20:33:34 +0200
In-Reply-To: <CAMG6FYgcep04reRKFe6vjpW+THbCT=+FnJ_-eLrcgE7+3UJEfA@mail.gmail.com> (sfid-20120509_202443_360152_9162C333)
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	 <4FA15A70.2020108@stericsson.com>
	 <CABF+-6VjWxN6mP4E+7WoR=RZxmSU70GPbua77Vmw+z=JnnKcUg@mail.gmail.com>
	 <CAMG6FYgcep04reRKFe6vjpW+THbCT=+FnJ_-eLrcgE7+3UJEfA@mail.gmail.com>
	 (sfid-20120509_202443_360152_9162C333)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-09 at 20:24 +0200, Dmitry Tarnyagin wrote:

> SDD files contains some kind of radio calibration data and Bluetooth
> arbitrage tables.
> They must be aligned with particular RF design and presence of Bluetooth PTA.
> If you are using PTA is your design, you should have SDD with PTA tables in.

Just to note, this is pretty ugly from a distro point of view, it
essentially means that no distro can possibly ship the firmware and you
can't get it included into linux-firmware.git either ...

Is there any way you could differentiate those to be able to ship them?

johannes

