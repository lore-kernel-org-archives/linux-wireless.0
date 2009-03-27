Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:59153 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbZC0GTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 02:19:24 -0400
Received: by bwz17 with SMTP id 17so848507bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 23:19:21 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
Date: Fri, 27 Mar 2009 07:19:13 +0100
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com> <200903262158.52601.helmut.schaa@gmail.com> <1238110011.10348.19.camel@rc-desk>
In-Reply-To: <1238110011.10348.19.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200903270719.14589.helmut.schaa@gmail.com> (sfid-20090327_071926_676600_A85B8369)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 27. M=C3=A4rz 2009 schrieb reinette chatre:
> On Thu, 2009-03-26 at 13:58 -0700, Helmut Schaa wrote:
> > 2) take the interface down when it gets rfkilled
> >=20
> > However, I'm not sure if 2 is possible without help of mac80211 and=
 if it
> > makes sense to change an interface state from within the driver.
>=20
> Like you say ... probably not the driver's place to do this.

Yeah, just ignore that idea ;)

Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
