Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:35302
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667AbYKVHtN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 02:49:13 -0500
From: Alexander <linalex1965@neuf.fr>
Reply-To: linalex1965@neuf.fr
To: linux-wireless@vger.kernel.org
Subject: Issues with AR5213A
Date: Sat, 22 Nov 2008 08:48:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200811220849.01619.linalex1965@neuf.fr> (sfid-20081122_084917_855527_CDB1B3ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Atheros Experts,

I have an issue with an atheros card that was working fine under suse10=
=2E3 after=20
installation of the madwifi drivers. When installing suse 11.0, a drive=
r was=20
automatically loaded, but it does not work.=20

I have posted the details here: http://forums.opensuse.org/network-
internet/wireless/400074-atheros-5005g-card-doesnt-find-signal.html#pos=
t1898247

Larry proposed me to mail the output of dmesg to you. I would appreciat=
e if=20
you could help me solving this issue.

Thanks in advance

Alexander=20

----------------------------------------------------

The critical section is as follows:

ath5k_pci 0000:02:00.0: registered as 'phy0'
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR5213A chip found (MAC: 0x78, PHY: 0x45)
ath5k phy0: RF2112A 2GHz radio found (0x56)
ADDRCONF(NETDEV_UP): wlan0: link is not ready
ath5k phy0: failed to wakeup the MAC Chip
ath5k phy0: can't reset hardware (-5)
pccard: card ejected from slot 0

It appears that the ath5k driver does not support the AR5213A.

Please post these lines to linux-wireless@vger.kernel.org. The Atheros =
experts
hang out there.

Larry
=EF=BF=BC=20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
