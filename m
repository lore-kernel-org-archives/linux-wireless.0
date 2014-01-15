Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:54954 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaAOU3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 15:29:37 -0500
Received: by mail-oa0-f42.google.com with SMTP id n16so1866544oag.29
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 12:29:37 -0800 (PST)
Message-ID: <52D6EFAD.40703@lwfinger.net> (sfid-20140115_212944_266357_31FDE4A8)
Date: Wed, 15 Jan 2014 14:29:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: andrea.merello@gmail.com
CC: Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	John Linville <linville@tuxdriver.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8187SE staging Linux driver
References: <CAN8YU5NTKUtS8+YzmcOSM3=YUX-FSwLTD86F_hXsNdVkw5NEGA@mail.gmail.com>	<522F584E.6000806@lwfinger.net>	<CAN8YU5PCFj-gtQwuuR3fM52YAVTi_5NYPbDVj-KMSzMpXjvFWQ@mail.gmail.com>	<CAN8YU5PGkx9s9deWpFTO_ZtDr-+wDD5cX2JRv1zd1m1Q0BpkCw@mail.gmail.com>	<52D6B31F.8080007@lwfinger.net>	<CAN8YU5NLzULTB1H0WMEfyL6jKn8naAM95fm3n0RT02KUXWe68Q@mail.gmail.com>	<52D6C871.7020302@lwfinger.net>	<CAN8YU5NqZxz0pjyk2dwLXRPaXeSCwp4bT37w6GtkbUQYuK53Rw@mail.gmail.com> <CAN8YU5NVS0Xi7Lx854AUpNm3agxW91p01tZMFgDwHZvhc=6B3w@mail.gmail.com>
In-Reply-To: <CAN8YU5NVS0Xi7Lx854AUpNm3agxW91p01tZMFgDwHZvhc=6B3w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/15/2014 12:43 PM, Andrea Merello wrote:
> should be
> +                (hw->max_signal < 0),
>
> I'm sorry, I did something wrong in my git commit

I would have expected <= 0. It is the zero value that causes the divide fault.

Larry


