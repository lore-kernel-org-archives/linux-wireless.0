Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65183 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1HRV0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2011 17:26:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAG1a4rt_NML2Q_Mkd+RuvLvft4D6inG7c9=s6kpAXqtAvatOBg@mail.gmail.com>
References: <CAG1a4rt_NML2Q_Mkd+RuvLvft4D6inG7c9=s6kpAXqtAvatOBg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 18 Aug 2011 14:26:20 -0700
Message-ID: <CAB=NE6UN4DEPNwt+TpOk6evr8_oz=ESqKWWGFh9KfROG1LJmiQ@mail.gmail.com> (sfid-20110818_232656_222196_8EFE25B9)
Subject: Re: [PATCH] ath9k: make driver usable standalone
To: Pavel Ivanov <paivanof@gmail.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 16, 2011 at 8:28 PM, Pavel Ivanov <paivanof@gmail.com> wrote:
> When ath9k is the only wireless driver included in the build
> WIRELESS_EXT configuration option becomes undefined. Because of that
> driver becomes essentially unusable as you can't actually connect to
> any WiFi network. By including WIRELESS_EXT into Kconfig we ensure
> that build with ath9k and without other drivers (having WIRELESS_EXT
> selected in their Kconfig) is actually usable.
>
> Signed-off-by: Pavel Ivanov <paivanof@gmail.com>

Fuck no, NACK.

  Luis
