Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:43498 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZC0GZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 02:25:46 -0400
Received: by bwz17 with SMTP id 17so849752bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 23:25:43 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
Date: Fri, 27 Mar 2009 07:25:34 +0100
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com> <200903262158.52601.helmut.schaa@gmail.com> <1238110011.10348.19.camel@rc-desk>
In-Reply-To: <1238110011.10348.19.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200903270725.35166.helmut.schaa@gmail.com> (sfid-20090327_072549_180364_0789B09A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am Freitag, 27. M=C3=A4rz 2009 schrieb reinette chatre:
> On Thu, 2009-03-26 at 13:58 -0700, Helmut Schaa wrote:
> > Assume the following situation:
> >=20
> > You only have one killswitch for both, wireless and bluetooth. The =
wireless
> > interface is down because it is unused and the user wants to use bl=
uetooth
> > and enables it via the killswitch which also means that wireless ge=
ts
> > unkilled. Now restarting the adapter needs more power then keeping =
the
> > adapter down. In short: if the interface is down the user (space) d=
oes not
> > want to use the interface and probably wants to save power as well.
>=20
> Your measurements are very fine grained :) Will this be measureable?

Heh, you know the internals of the devive ;) but I guess waking up the
adapter (and thus starting the firmware) even if the interface is unuse=
d
will surely need more power than not doing so.

Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
