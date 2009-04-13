Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:32716 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbZDMUFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 16:05:36 -0400
Received: by fg-out-1718.google.com with SMTP id e12so690576fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 13:05:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <471624.65405.qm@web23103.mail.ird.yahoo.com>
References: <471624.65405.qm@web23103.mail.ird.yahoo.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 13 Apr 2009 22:05:20 +0200
Message-ID: <69e28c910904131305xd395d44leb36adb1284560e1@mail.gmail.com> (sfid-20090413_220541_007729_77D47FB0)
Subject: Re: [PATCH] rtl8187: Remove the "8187B chip detected" message when
	probing RTL8187B cards
To: htl10@users.sourceforge.net
Cc: John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2009 at 9:59 PM, Hin-Tak Leung
<htl10@users.sourceforge.net> wrote:
>
>
>
> --- On Mon, 13/4/09, G=E1bor Stefanik <netrolller.3d@gmail.com> wrote=
:
>
>> This message appears to be nothing
>> more than a leftover of the
>> experimental-8187B era. Also, we print the HW type in the
>> hwaddr line,
>> making this message reduntant. And it's definitely not
>> important
>> enough to be a KERN_WARNING.
>>
>> Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
>
> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
>
> Indeed - that printk doesn't really say anything useful.

=46or the record, I originally wanted to add an equivalent "8187L
detected" message, but then I noticed that the HW type is printed in
the hwaddr line, making any further printks redundant.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
