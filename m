Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:51267 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbZE0Ic4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 04:32:56 -0400
Received: by bwz22 with SMTP id 22so4402512bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2009 01:32:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243409295-8363-1-git-send-email-linville@tuxdriver.com>
References: <1243409295-8363-1-git-send-email-linville@tuxdriver.com>
Date: Wed, 27 May 2009 09:32:57 +0100
Message-ID: <3ace41890905270132l20fca1a0i41a7151ce80997ba@mail.gmail.com>
Subject: Re: [PATCH] rtl8187: add USB ID for Linksys WUSB54GC-EU v2 USB wifi
	dongle
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Przemyslaw Kulczycki <azrael@autocom.pl>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2009 at 8:28 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13383
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

could add a line to drivers/net/wireless/Kconfig under the rt;8187
section as well? This seems to be the first Linksys device to use the
chip.

Hin-Tak
