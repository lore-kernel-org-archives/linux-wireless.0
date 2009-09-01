Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:56948 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZIAQG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 12:06:56 -0400
Message-ID: <4A9D469B.9060005@lwfinger.net>
Date: Tue, 01 Sep 2009 11:06:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	aquilaver@yahoo.com, linux-kernel@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>,
	Kai Engert <kengert@redhat.com>,
	Jean Tourrilhes <jt@hpl.hp.com>,
	Tim de Waal <tim.dewaal@yahoo.com>,
	Roy Marples <uberlord@gentoo.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Christian Lamparter <chunkeey@web.de>,
	=?UTF-8?B?QmrDtnJuIFN0ZWluYnJpbms=?= <B.Steinbrink@gmx.de>,
	Tim Gardner <tim.gardner@canonical.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] wireless: mark prism54 as deprecated and mark for removal
References: <1251819116-10004-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1251819116-10004-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> The preferred modules is p54 which also supports FullMAC

This needs to be "modules are" or "module is". I know p54 is really a
family, but I think you specifically mean p54pci here.

> PCI / Cardbus devices. We schedule removal for 2.6.34. Reason
> to remove this is no one really is testing prism54 anymore,
> and while it works p54 provides support for the same hardware.
                     ===
p54pci?

> It should be noted I have been told some FullMAC devices may not
> have worked with the SoftMAC driver but to date we have yet to
> recieve a single bug report regarding this. If there are users
  =======
receive

> out there please let us know!
  =========

Those words can be removed.

Otherwise, ACK.

Larry

