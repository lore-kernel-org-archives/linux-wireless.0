Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:9414 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbZAANkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2009 08:40:40 -0500
Message-ID: <69e28c910901010540r5e79431cjf6ad1a76f06ff0fd@mail.gmail.com> (sfid-20090101_144045_213890_06C66E20)
Date: Thu, 1 Jan 2009 14:40:31 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
Cc: htl10@users.sourceforge.net,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Alan Stern" <stern@rowland.harvard.edu>,
	"Bob Copeland" <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	"USB list" <linux-usb@vger.kernel.org>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
In-Reply-To: <495CC024.9020009@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <471208.74701.qm@web23104.mail.ird.yahoo.com>
	 <495CC024.9020009@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 1, 2009 at 2:07 PM, Alan Jenkins
<alan-jenkins@tuffmail.co.uk> wrote:
> Hin-Tak Leung wrote:
>> --- On Wed, 31/12/08, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
>>
>>
>>> Thanks for the patch.  I tested STD too, and it doesn't
>>> seem to hang
>>> anymore.  I even tested removing the adaptor while the
>>> system was
>>> hibernated.  However, after resume the interface is
>>> useless.
>>>
>>
>> Wierd - do you have NetworkManager running?
>>
>
> Yes, but it's not managing the wireless interface - I'm still using the
> wired network.  When I tested, I didn't use the wireless interface at
> all before I hibernated.
>
>> These days I leave NM running - besides the occasional /etc/rc.d/init.d/{wpa_supplicant/NetworkManager} stop/start to re-establish connectivity (seems to be some timing issue with dhcp taking too long and nm ifconfig up/down the device wrongly) - and *when STD/STR works*, NM usually just re-connect within a minute on resume/defrost.
>>
>> I don't have the choice of unhooking the device - integrated to laptop. BTW, is it a B device or a non-B device that didn't work?
>>
>
> I think it's a B device.
>
> phy0: hwaddr 00:1b:2f:76:02:bc, RTL8187vB (default) V1 + rtl8225z2
>
>
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

That is an RTL8187L, rev. B. It is not an RTL8187B.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
