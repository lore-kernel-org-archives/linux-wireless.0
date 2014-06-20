Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25784 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbaFTQnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 12:43:40 -0400
From: "Kondratiev, Vladimir" <vkondrat@qti.qualcomm.com>
To: Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	qca_vkondrat <qca_vkondrat@qca.qualcomm.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wil6210 <wil6210@qca.qualcomm.com>,
	netdev <netdev@vger.kernel.org>
Subject: RE: randconfig build error with next-20140604, in
 drivers/net/wireless/ath/wil6210/debugfs.c
Date: Fri, 20 Jun 2014 16:43:38 +0000
Message-ID: <A5CA08B46412E243958C77F3825F4395270AB72A@NASANEXD02E.na.qualcomm.com> (sfid-20140620_184401_973821_79665A82)
References: <CA+r1ZhiT6hHwA2urc-DXUxucvJYaYdq-dZZSAFrgd3du_DDrww@mail.gmail.com>
In-Reply-To: <CA+r1ZhiT6hHwA2urc-DXUxucvJYaYdq-dZZSAFrgd3du_DDrww@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Building with the attached random configuration file,

drivers/built-in.o: In function `wil_vring_debugfs_show':
debugfs.c:(.text+0x3a331c): undefined reference to `__udivdi3'
make: *** [vmlinux] Error 1

Patch already sent.

Thanks, Vladimir