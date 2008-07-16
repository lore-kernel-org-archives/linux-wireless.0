Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound-mail-130.bluehost.com ([67.222.38.30]:39236 "HELO
	outbound-mail-130.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755904AbYGPQiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 12:38:03 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [PATCH 5/5] Ath5k: suspend/resume fixes
Date: Wed, 16 Jul 2008 09:31:11 -0700
Cc: "Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com> <1216136661-10930-4-git-send-email-jirislaby@gmail.com> <40f31dec0807160915g8a5b083p9f21fae729839445@mail.gmail.com>
In-Reply-To: <40f31dec0807160915g8a5b083p9f21fae729839445@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807160931.11473.jbarnes@virtuousgeek.org> (sfid-20080716_183807_144088_2F7488F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, July 16, 2008 9:15 am Nick Kossifidis wrote:
> It's ok for now, but have in mind that on my upcoming patch series i'm
> disabling msi (commented out) since it results no interrupts on pci-e
> cards (seems there is a bug in kernel's msi implementation).

Hm, would be good to get details here.  MSI is being used by other drivers 
successfully...

Jesse
