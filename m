Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:35518 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079AbYFKUBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 16:01:44 -0400
Message-ID: <48502F43.6040000@lwfinger.net> (sfid-20080611_220146_993295_3AD651A0)
Date: Wed, 11 Jun 2008 15:02:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>,
	Tim Gardner <tim.gardner@canonical.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: Re: Open source driver with binary HAL for BCM4313 from Broadcom
References: <48500F14.8070300@canonical.com> <200806112047.00854.mb@bu3sch.de> <69e28c910806111250k4bfe0190h9cfd5937d47b1bbc@mail.gmail.com>
In-Reply-To: <69e28c910806111250k4bfe0190h9cfd5937d47b1bbc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefanik G=E1bor wrote:
> On Wed, Jun 11, 2008 at 8:47 PM, Michael Buesch <mb@bu3sch.de> wrote:
>> On Wednesday 11 June 2008 19:44:52 Tim Gardner wrote:
>>> John,
>>>
>>> Here is the URL to Broadcom's web site advertising their open sourc=
e
>>> driver with support for the BCM4313.
>>>
>>> http://www.broadcom.com/support/802.11/linux_sta.php
>>>
>>> rtg
>> <quote>
>> Make sure that you download the appropriate tar because the hybrid b=
inary
>> file must be of the appropriate architecture type. The hybrid binary=
 file
>> is agnostic to the specific version of the Linux kernel because it i=
s
>> designed to perform all interactions with the operating system throu=
gh
>> operating-system-specific files...
>> </quote>
>>
>> --
>> Greetings Michael.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wire=
less" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> Also, the download links are broken. And AFAIK we do support BCM4312,
> although not PCI ID 0x4315 (that would be BCM4310).
> (CCing the bcm43xx mailing list.)

Watch out for their tarballs as they will dump all over the directory=20
that you are in when you invoke tar.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
