Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:38700 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbZAMXet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 18:34:49 -0500
Received: by fg-out-1718.google.com with SMTP id 19so161577fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 15:34:47 -0800 (PST)
Message-ID: <69e28c910901131534g28404687y6bf23bdbbb233b26@mail.gmail.com> (sfid-20090114_003453_926503_38D634E3)
Date: Wed, 14 Jan 2009 00:34:47 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Delphi Real Estate" <Info@delphi-real-estate.com>
Subject: Re: 'N' Mode and 5GHz, Also WPA2
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200901131502.01047.Info@delphi-real-estate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200901131502.01047.Info@delphi-real-estate.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 14, 2009 at 12:02 AM, Delphi Real Estate
<Info@delphi-real-estate.com> wrote:
>
> Running the Intel 4965AGP with iwlagn driver that comes in Ubuntu kernel 2.6.27.10, and DLink DIR-825 dual-mode router.
>
> Despite extensive effort and research I have been unable to associate in 'n' mode at 5GHz.  I can associate and communicate in 'g' and 'n' mode at 2.4GHz, and in 'a' mode at 5GHz, but it simply does not work in 'n' at 5.  Has anyone been able to make this work?
>
> Does anyone know what chipset is in the DIR-825?  Should I crack it open?

Try checking its FCC ID on the Equipment Authorization page. It has
internal photos.

>
> Also I am unable to associate in any mode in any band, with WPA2.  Has anyone got WPA2 working with the iwlagn driver?

Are you running the latest wpa_supplicant?

>
> Best,
>
> Bill
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
