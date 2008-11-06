Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23104.mail.ird.yahoo.com ([217.146.189.44]:36763 "HELO
	web23104.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750733AbYKFUtn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 15:49:43 -0500
Date: Thu, 6 Nov 2008 20:49:41 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <49124B87.7050901@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <77146.91148.qm@web23104.mail.ird.yahoo.com> (sfid-20081106_214946_678771_A43F438A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The actual throughput transferring a 700MB file via sftp between my client and the AP doesn't go much over 50KB/s (according to sftp's progress meter). It used to be over 400KB/s under the same situation. The rate shown by
iwconfig is consistently 1Mb/s while manually setting it to 36/48Mb doesn't
change the throughput. (at the moment it is looking like it will take 4
hours to transfer, instead of the usual 20+ minutes).

how can I see what's wrong? (I have another few hours while it finishes, and of course, I can always try again...).


      
