Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39639 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1FCNsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 09:48:40 -0400
Subject: Re: [PATCH 1/6] NFC: add nfc subsystem core
From: Johannes Berg <johannes@sipsolutions.net>
To: Aloisio Almeida <aloisio.almeida@openbossa.org>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcio.macedo@openbossa.org,
	sameo@linux.intel.com, Waldemar.Rymarkiewicz@tieto.com
In-Reply-To: <BANLkTinJ8-i7z-nN1_UxwDX-rVD+jy85XA@mail.gmail.com> (sfid-20110603_154549_251141_B43F5DDF)
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
	 <1307051170-17374-2-git-send-email-lauro.venancio@openbossa.org>
	 <1307108134.3800.1.camel@jlt3.sipsolutions.net>
	 <BANLkTinJ8-i7z-nN1_UxwDX-rVD+jy85XA@mail.gmail.com>
	 (sfid-20110603_154549_251141_B43F5DDF)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 15:48:37 +0200
Message-ID: <1307108917.3800.8.camel@jlt3.sipsolutions.net> (sfid-20110603_154843_154966_9944AFE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-03 at 10:45 -0300, Aloisio Almeida wrote:
> On Fri, Jun 3, 2011 at 10:35 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2011-06-02 at 18:46 -0300, Lauro Ramos Venancio wrote:
> >
> >> +struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
> >> +                                     u32 supported_protocols);
> >
> > Where do the protocols come from? I don't see any defines for them?
> 
> The defines are on the patch 2/6 (generic netlink): NFC_PROTO_*

Yeah, just found them too, thanks.

johannes

