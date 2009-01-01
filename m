Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23104.mail.ird.yahoo.com ([217.146.189.44]:24569 "HELO
	web23104.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751036AbZAAGSz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2009 01:18:55 -0500
Date: Thu, 1 Jan 2009 06:18:52 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <495B82CB.6050205@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <471208.74701.qm@web23104.mail.ird.yahoo.com> (sfid-20090101_071917_205230_E091C15C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 31/12/08, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:

> Thanks for the patch.  I tested STD too, and it doesn't
> seem to hang
> anymore.  I even tested removing the adaptor while the
> system was
> hibernated.  However, after resume the interface is
> useless.

Wierd - do you have NetworkManager running?

These days I leave NM running - besides the occasional /etc/rc.d/init.d/{wpa_supplicant/NetworkManager} stop/start to re-establish connectivity (seems to be some timing issue with dhcp taking too long and nm ifconfig up/down the device wrongly) - and *when STD/STR works*, NM usually just re-connect within a minute on resume/defrost.

I don't have the choice of unhooking the device - integrated to laptop. BTW, is it a B device or a non-B device that didn't work?

Hin-Tak 


      
