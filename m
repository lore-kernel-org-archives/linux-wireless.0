Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:60440 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYLRMzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 07:55:13 -0500
Received: by bwz14 with SMTP id 14so1476351bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 04:55:11 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC][RFT] fix iwlagn hw-rfkill while the interface is down
Date: Thu, 18 Dec 2008 13:54:45 +0100
Cc: mohamed salim abbas <mabbaswireless@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	yi.zhu@intel.com, reinette.chatre@intel.com
References: <200812161307.07193.helmut.schaa@gmail.com> <b3153e950812171210n7247bevc9470fa47942ce92@mail.gmail.com> <20081217202943.GB3516@tuxdriver.com>
In-Reply-To: <20081217202943.GB3516@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812181354.45839.helmut.schaa@gmail.com> (sfid-20081218_135519_146370_DAE47DDF)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 17. Dezember 2008 schrieb John W. Linville:
> I think it still isn't settled in everyone's minds whether rfkill
> only matters if the device is "up" or if it is something that
> e.g. NetworkManager might want to monitor as a clue to bring the
> device up or down in response to rfkill changes.

I guess we need a concrete definition if the rfkill state is bound to
iface up/down or not. However I think it's somwhat awkward to expose an
(maybe) incorrect rfkill state if the interface is down. Either the state
should be correct or not exposed at all.

Helmut
