Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:13643 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbYF1Pcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 11:32:31 -0400
Received: by wf-out-1314.google.com with SMTP id 27so883066wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 08:32:31 -0700 (PDT)
Message-ID: <69e28c910806280832j453317cdma2be11f343c32712@mail.gmail.com> (sfid-20080628_173306_551913_ADDC3AD1)
Date: Sat, 28 Jun 2008 17:32:31 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Problem making compat-wireless-2.6
Cc: "George Fong" <george@lateralplains.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20080628151056.GA6110@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200806281953.16371.george@lateralplains.com>
	 <69e28c910806280421t5e0de8edm8d6aab9cd582ccb7@mail.gmail.com>
	 <20080628151056.GA6110@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 28, 2008 at 5:10 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sat, Jun 28, 2008 at 01:21:54PM +0200, Stefanik G=E1bor wrote:
>
>> Try editing drivers/net/wireless/b43/rfkill.c, and replacing
>> RFKILL_STATE_UNBLOCKED with RFKILL_STATE_ON and
>> RFKILL_STATE_SOFT_BLOCKED with RFKILL_STATE_OFF. Looks like rfkill i=
s
>> not part of the compat package, and no work has been done to match
>> compat-wireless to older RFKILLs.
>
> FWIW, rfkill probably _should_ be in compat-wireless.  Luis?
>
> John
> --
> John W. Linville
> linville@tuxdriver.com
>

John's proposal Acked-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
