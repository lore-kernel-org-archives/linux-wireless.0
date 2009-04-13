Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:11516 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZDMXtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 19:49:21 -0400
Received: by fg-out-1718.google.com with SMTP id e12so712449fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 16:49:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <42609.6548.qm@web23108.mail.ird.yahoo.com>
References: <42609.6548.qm@web23108.mail.ird.yahoo.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 14 Apr 2009 01:49:05 +0200
Message-ID: <69e28c910904131649s7e735380i10c739d27ad0766f@mail.gmail.com> (sfid-20090414_014925_892886_92FFB710)
Subject: Re: [PATCH RFC] rtl8187: Call 8187L variants "RTL8187LvX" rather than
	"RTL8187vX"
To: htl10@users.sourceforge.net
Cc: John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2009 at 10:29 PM, Hin-Tak Leung
<htl10@users.sourceforge.net> wrote:
>
> --- On Mon, 13/4/09, G=E1bor Stefanik <netrolller.3d@gmail.com> wrote=
:
>
>> We call RTL8187B chips "RTL8187BvX"
>> (X is the revision), so we should
>> call RTL8187L ones "RTL8187LvX", not "RTL8187vX".
>>
>> Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
>
> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
>
> I don't have a preference either way - if any, I would probably prefe=
r without the change, or use a space for readability rather than 'L', b=
ecause the 'L' just isn't there most of the time, and there is B (which=
 is similiar but not the same) and SE (which is completely different). =
It might be worth also to put a space after the B's.
>
> The way that string is currently done is largely inherited from the v=
endor driver, I think.

What do you mean by "the 'L' just isn't there most of the time"? AFAIK
there is no RTL8187 chip (without a letter suffix), only RTL8187L,
RTL8187B and RTL8187SE, and 8187L is not much more common that 8187B,
to warrant calling it "RTL8187" in any case.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
