Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12994 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYLSUvd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 15:51:33 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 12:51:33 -0800
Date: Fri, 19 Dec 2008 12:51:29 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: drago01 <drago01@gmail.com>
CC: Zhu Yi <yi.zhu@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH 00/43] iwl3945 merges into iwlagn (Dec 19)
Message-ID: <20081219205129.GD15227@tesla> (sfid-20081219_215138_935975_59A4060A)
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com> <f6ca9fed0812191132h2f76ce40id20c52bdb6e0681c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <f6ca9fed0812191132h2f76ce40id20c52bdb6e0681c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 11:32:53AM -0800, drago01 wrote:
> On Fri, Dec 19, 2008 at 3:37 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> > Hi John,
> >
> > Here is the first batch for the iwl3945 -> iwlagn merge. This is for
> > post .29 kernel.
> 
> Well it doesn't really matter but wouldn't it make sense to rename the
> driver back to iwlwifi ? (as 3945 does not support n mode)

That would make compat-crap stuff difficult, at least I cannot think of an
easy way to deal with it. See scripts/iwl-load, part of compat-wireless. This
is used to simply rename iwl4965 to iwl4965.ignore and let iwlagn kick in
if you are on an older kernel. If we move iwlagn to iwlwifi... umm.. wait did
we ever have an "iwlwifi" driver?

  Luis
