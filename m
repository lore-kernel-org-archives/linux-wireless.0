Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:49067 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZFPQYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 12:24:16 -0400
Subject: Re: [PATCH 4/4] rfkill: export persistent attribute in sysfs
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A37A3FC.9060206@tuffmail.co.uk>
References: <4A37A3FC.9060206@tuffmail.co.uk>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 18:24:14 +0200
Message-Id: <1245169454.15367.25.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alan,

> This information allows userspace to implement a hybrid policy where
> it can store the rfkill soft-blocked state in platform non-volatile
> storage if available, and if not then file-based storage can be used.
> 
> Some users prefer platform non-volatile storage because of the behaviour
> when dual-booting multiple versions of Linux, or if the rfkill setting
> is changed in the BIOS setting screens, or if the BIOS responds to
> wireless-toggle hotkeys itself before the relevant platform driver has
> been loaded.
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

as I mentioned before, I agree with doing it this way.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


