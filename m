Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37758 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab1AaPI3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 10:08:29 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 00/18] wl1251: feature ports / monitor mode / packet injection
References: <4D45A583.3060605@davizone.at> <4D45B7B2.40001@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 31 Jan 2011 17:08:27 +0200
In-Reply-To: <4D45B7B2.40001@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 20\:10\:42 +0100")
Message-ID: <87r5btdsb8.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

David Gnedt <david.gnedt@davizone.at> writes:

> Patch 01-03 fix some bugs.
> Patch 04-09 contain some feature ports from Maemo Fremantle and wl1271.
> Patch 10-18 implement (mainly) monitor mode and packet injection.

How did you test the patches? For example, what hardware did you use
etc.

About the code from fremantle kernels. Few weeks ago nokia sent me
privately the original patches from their internal git tree, I gave
some comments and never heard back. So, in theory I should have all
the fremantle patches somewhere in my email archives. I would just
need to clean them up and send them here. I'll go over your patches
and let's see what we should do.

> Sorry for the partly broken patches, I thought I configured my client the
> right way. I tried to stop the mails at my mailserver, but it was mostly
> already too late.

No problem. But whenever you resend your patchset, please add a
revision to them, otherwise it's impossible to know which patch is
which. Good way is to use tag "[PATCH v2]" or similar.

-- 
Kalle Valo
