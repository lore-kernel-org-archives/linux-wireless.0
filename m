Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:38838 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab0CRK7X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:59:23 -0400
Date: Thu, 18 Mar 2010 11:59:17 +0100
From: Florian Mickler <florian@mickler.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: florian@mickler.org, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
	Valdis.Kletnieks@vt.edu, "Marcel Holtmann" <marcel@holtmann.org>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Randy Dunlap" <rdunlap@xenotime.net>,
	"Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] rename new rfkill sysfs knobs
Message-ID: <20100318115917.64b7268f@schatten.dmk.lab>
In-Reply-To: <1268483465-11810-1-git-send-email-florian@mickler.org>
References: <20100313095626.GB16038@core.coreip.homeip.net>
	<1268483465-11810-1-git-send-email-florian@mickler.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 13 Mar 2010 13:31:05 +0100
florian@mickler.org wrote:

> This patch renames the (never officially released) sysfs-knobs
> "blocked_hw" and "blocked_sw" to "hard" and "soft", as the hardware vs
> software conotation is misleading.
> 
> It also gets rid of not needed locks around u32-read-access.
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>

Is this ok?

cheers,
Flo
