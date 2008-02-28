Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.232]:48784 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYB1W4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 17:56:21 -0500
Received: by wr-out-0506.google.com with SMTP id c48so5481240wra.23
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2008 14:56:21 -0800 (PST)
Message-ID: <43e72e890802281456j22236cdegb4cf0c90d954af05@mail.gmail.com> (sfid-20080228_225632_634223_8113A9A0)
Date: Thu, 28 Feb 2008 17:56:15 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/8] ath5k: latest revised patches
Cc: ath5k-devel@lists.ath5k.org, "Jiri Slaby" <jirislaby@gmail.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Bob Copeland" <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following are based on Nick's patches, they address checkpatch
complaints, make use of pci_dev's is_pcie, and makes use of a helper
instead on the 7th patch. These need testing on pci-e cards. I've
tested it on AR5213 (MAC 0x56, PHY: 0x41), RF5211 (0x17) and RF2111
(0x23).

You can also wget them from:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath5k/2008-02-28/

  Luis
