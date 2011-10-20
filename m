Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm21-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.137]:36909 "HELO
	nm21-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932108Ab1JTLZK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 07:25:10 -0400
Message-ID: <1319109568.26974.YahooMailNeo@web161206.mail.bf1.yahoo.com> (sfid-20111020_132514_412175_EBA98830)
Date: Thu, 20 Oct 2011 04:19:28 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Reply-To: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: ath5k: controlling powersave with iw or iwconfig fails
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-users@lists.ath5k.org" <ath5k-users@lists.ath5k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
trying to disable PS on ath5k (Linux 3.0) gives:

iw dev wlan0 set power_save off
command failed: Operation not supported (-95)


Is there any special magic required to disable power saving?
It seems to interfere with our amplifier... 

 
-- 
Regards 
Joerg 

