Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2FELGr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 07:06:47 -0400
Message-ID: <1338894402.4514.28.camel@jlt3.sipsolutions.net> (sfid-20120605_130651_117340_FC3D1AB2)
Subject: Re: Connected standby support ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Matt Chen <mattsled@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, users@rt2x00.serialmonkey.com,
	joeyli <jlee@suse.com>, Michael Chang <mchang@suse.com>
Date: Tue, 05 Jun 2012 13:06:42 +0200
In-Reply-To: <CALx5=V8gS-FudA0EAmoEs=xwQ7hr_BntO4Jr_+6tR9pYSNDUdg@mail.gmail.com> (sfid-20120605_045346_656263_57F140A7)
References: <CALx5=V8gS-FudA0EAmoEs=xwQ7hr_BntO4Jr_+6tR9pYSNDUdg@mail.gmail.com>
	 (sfid-20120605_045346_656263_57F140A7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-05 at 10:53 +0800, Matt Chen wrote:
> Hi list,
> As the incoming UEFI new design for BIOS, Microsoft has already
> provided a model, "connected standby",  for power management. There
> are 3 modes which are S0, Low Power S0 and S5.
> I am wondering if there is already any support for the connected
> standby in wifi of Linux ?

That's what we call wowlan, right? Or can be implemented using it?

johannes


