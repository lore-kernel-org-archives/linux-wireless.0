Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f45.google.com ([209.85.212.45]:53198 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab3HVWTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 18:19:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMQbqHRkF4_gK=GA587LDghkYtd1hRQhLObV+Tbe9zEDbS5-Q@mail.gmail.com>
References: <CAOMQbqHRkF4_gK=GA587LDghkYtd1hRQhLObV+Tbe9zEDbS5-Q@mail.gmail.com>
Date: Fri, 23 Aug 2013 02:19:40 +0400
Message-ID: <CA++WF2NGdNBcB4Jb=MOGko+n9TgT++BkR8qXP=QcPu4rEBBhuA@mail.gmail.com> (sfid-20130823_001959_608120_93E0E136)
Subject: Re: ipw2200: Fix race condition in the command completion acknowledge
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Stan G <stangoesagain@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stan,

> I am having intermittent problems with dropping wifi network while the  AP
> is still visible and dmesg produces this:
>
>       [26617.864791] ipw2200: Failed to send ASSOCIATE: Already sending a
> command.
>

Thank you for the information, I will take a look. Could you please
reproduce the problem with debug information enabled?

modprobe -rv ipw2200
modprobe -v ipw2200 debug=0x1000

Stanislav.
