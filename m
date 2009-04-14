Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64888 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbZDNAnl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 20:43:41 -0400
Received: by fxm2 with SMTP id 2so2207761fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 17:43:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E3D7E9.6090501@lwfinger.net>
References: <42609.6548.qm@web23108.mail.ird.yahoo.com> <69e28c910904131649s7e735380i10c739d27ad0766f@mail.gmail.com>
	<49E3D7E9.6090501@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 14 Apr 2009 02:43:25 +0200
Message-ID: <69e28c910904131743p57af0ae1q5fae0f02d90e035@mail.gmail.com> (sfid-20090414_024349_407663_28B8F639)
Subject: Re: [PATCH RFC] rtl8187: Call 8187L variants "RTL8187LvX" rather than
	"RTL8187vX"
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: htl10@users.sourceforge.net,
	John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/14 Larry Finger <Larry.Finger@lwfinger.net>:
> G=E1bor Stefanik wrote:
>> What do you mean by "the 'L' just isn't there most of the time"? AFA=
IK
>> there is no RTL8187 chip (without a letter suffix), only RTL8187L,
>> RTL8187B and RTL8187SE, and 8187L is not much more common that 8187B=
,
>> to warrant calling it "RTL8187" in any case.
>>
>
> For some reason, that is exactly what the vendor driver does. There a=
re several
> places that refer to RTL8187B, but nowhere do they talk about the RTL=
8187. They
> do, however, refer to the RTL8187L as the chip name on their Web pile=
=2E
>
> Larry

The actual chips also have RTL8187L printed on them.

--G=E1bor


--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
