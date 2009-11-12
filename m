Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:48303 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZKLOnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 09:43:55 -0500
Received: by fg-out-1718.google.com with SMTP id d23so2082259fga.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 06:44:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4afb8fa1.BSj+U96EOaXrlQvr%Larry.Finger@lwfinger.net>
References: <4afb8fa1.BSj+U96EOaXrlQvr%Larry.Finger@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 12 Nov 2009 15:43:40 +0100
Message-ID: <69e28c910911120643l7321818ci1fd6479821e3b9f7@mail.gmail.com>
Subject: Re: [RFC/RFT 0/6 V2] rtl8187se: Initial introduction of driver
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, bzolnier@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Might be worthy in the long run to create a common rtl81xx library
module, especially when work on RTL819x begins.

On Thu, Nov 12, 2009 at 5:31 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Patches to introduce a driver for the RTL8187SE PCI-based device.
>
> Note: This driver is only compile-tested and will require more work
> for it to be useful. I'm posting now to let others know what I have done.
>
> I have applied for an account at kernel.org. If my request is approved, I
> plan to establish an rtl8187se git tree.
>
> Patch 1/6: Create file rtl8187se.h
> Patch 2/6: Create file rtl8187se_dev.c
> Patch 3/6: Create file rtl8187se_rtl8225.c
> Patch 4/6: Create file rtl8187se_rtl8225.h
> Patch 5/6: Modify file rtl818x.h
> Patch 6/6: Modify Kconfig and Makefile for rtl8187se
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
