Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:60224 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab1EXQuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 12:50:54 -0400
Subject: Re: [iwl4965] Microcode SW error detected
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110524070941.GA2189@redhat.com>
References: <1306151106.2066.60.camel@x61.thuisdomein>
	 <20110524070941.GA2189@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 18:50:53 +0200
Message-ID: <1306255853.12267.14.camel@x61.thuisdomein> (sfid-20110524_185058_157074_9942A94B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-24 at 09:09 +0200, Stanislaw Gruszka wrote:
> What is your configuration (mode,
> encryption, do you use wpa_supplicant or NetworkManager, which version,
> etc ...)?

0) Mode as is displayed in iwconfig output? That is "Managed".

1) Encryption is wep (so, no wpa_supplicant).

2) Currently using NetworkManager-0.8.4-1.fc14.x86_64.

> I will try to reproduce locally. If I'll be not able to reproduce,
> I'll ask you for debug logs on broken, and working (i.e. 2.6.38) version
> for compare.

3) Sure, no problem. But isn't 2.6.38 from before the iwlegacy split?


Paul Bolle

