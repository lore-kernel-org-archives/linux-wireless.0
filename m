Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:25533 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429AbYKDQwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 11:52:41 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1639390qwe.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 08:52:40 -0800 (PST)
Message-ID: <69e28c910811040852u7f3f3481t7bf31ad3af8c03ad@mail.gmail.com> (sfid-20081104_175256_109274_E34D4749)
Date: Tue, 4 Nov 2008 17:52:40 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Wilson Ribeiro" <wribjr@gmail.com>
Subject: Re: Realtek wireless 8187se
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <740646d0811040501w5571d464u757e05399803f768@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <740646d0811040501w5571d464u757e05399803f768@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 4, 2008 at 2:01 PM, Wilson Ribeiro <wribjr@gmail.com> wrote=
:
> Hi people,
>
> i recently bought a MSI Wind and it came with a wireless nic
> rtl8187se, is there support on current stable kernel for that wireles=
s
> card?
>
> Thanks,
>
> --
> Wilson Ribeiro
> Consultor de Tecnologia da Informa=E7=E3o
> e-mail: wribjr@gmail.com
> phone: 55 21 34117748
> mobile: 55 21 82424280
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Can you check the actual print on the chip itself? "RTL8187L" and
"RTL8187B" are supported currently. Also, what is the USB device ID of
the chip? 0x8187, 0x8189, 0x8197 and 0x8198 are known to work in the
latest preview kernels.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
