Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:52090 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbZAANHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2009 08:07:54 -0500
Message-ID: <495CC024.9020009@tuffmail.co.uk> (sfid-20090101_140800_177381_EABE490B)
Date: Thu, 01 Jan 2009 13:07:48 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
References: <471208.74701.qm@web23104.mail.ird.yahoo.com>
In-Reply-To: <471208.74701.qm@web23104.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> --- On Wed, 31/12/08, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
>
>   
>> Thanks for the patch.  I tested STD too, and it doesn't
>> seem to hang
>> anymore.  I even tested removing the adaptor while the
>> system was
>> hibernated.  However, after resume the interface is
>> useless.
>>     
>
> Wierd - do you have NetworkManager running?
>   

Yes, but it's not managing the wireless interface - I'm still using the
wired network.  When I tested, I didn't use the wireless interface at
all before I hibernated.

> These days I leave NM running - besides the occasional /etc/rc.d/init.d/{wpa_supplicant/NetworkManager} stop/start to re-establish connectivity (seems to be some timing issue with dhcp taking too long and nm ifconfig up/down the device wrongly) - and *when STD/STR works*, NM usually just re-connect within a minute on resume/defrost.
>
> I don't have the choice of unhooking the device - integrated to laptop. BTW, is it a B device or a non-B device that didn't work?
>   

I think it's a B device.

phy0: hwaddr 00:1b:2f:76:02:bc, RTL8187vB (default) V1 + rtl8225z2


Alan
