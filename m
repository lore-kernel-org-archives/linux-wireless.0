Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:51676 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbZLCPBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 10:01:44 -0500
Date: Thu, 3 Dec 2009 15:01:35 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	kde-hardware-devel@kde.org, dbus@lists.freedesktop.org,
	linux-wireless@vger.kernel.org, hal@lists.freedesktop.org,
	linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
	networkmanager-list@gnome.org, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 32/33] input: add KEY_WIRELESS_CYCLE
Message-ID: <20091203150135.GB23212@srcf.ucam.org>
References: <1259826317-18809-30-git-send-email-corentincj@iksaif.net> <1259826317-18809-31-git-send-email-corentincj@iksaif.net> <1259826317-18809-32-git-send-email-corentincj@iksaif.net> <1259826317-18809-33-git-send-email-corentincj@iksaif.net> <20091203075404.GK9121@core.coreip.homeip.net> <71cd59b00912030012r2f45f474u37c494ad281230cb@mail.gmail.com> <20091203082120.GL9121@core.coreip.homeip.net> <71cd59b00912030051w6bf54abfv726f288c2eae1d33@mail.gmail.com> <20091203085717.GO9121@core.coreip.homeip.net> <71cd59b00912030122n3d94236ajfa5e55c3b5a9efcd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <71cd59b00912030122n3d94236ajfa5e55c3b5a9efcd@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 03, 2009 at 10:22:16AM +0100, Corentin Chary wrote:

> Dear system infrastructure people,
> Do you think a KEY_WIRELESS_CYCLE key would have any application ?

Not really. I've got a KEY_RFKILL patch queued, with the intended 
semantics being for rfkill-input to just toggle all devices. If a 
userspace rfkill daemon is running, it could use that to implement the 
cycle policy you want. I don't think we need both.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
