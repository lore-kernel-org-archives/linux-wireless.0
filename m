Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f194.google.com ([209.85.212.194]:35324 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbbKCI00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 03:26:26 -0500
Received: by wicuv6 with SMTP id uv6so1238755wic.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2015 00:26:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5636BFA6.5070500@atmel.com>
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
	<1446174642-28570-17-git-send-email-glen.lee@atmel.com>
	<5636BFA6.5070500@atmel.com>
Date: Tue, 3 Nov 2015 13:56:24 +0530
Message-ID: <CAKHNQQF+DEZmv83Lo=S4qAd85ffdPgftCuZ-nbGPCSKFAAXhBA@mail.gmail.com> (sfid-20151103_092629_938616_FDA4D7C6)
Subject: Re: About the patch "Staging: wilc1000: coreconfigurator: Drop
 unneeded wrapper functions"
From: Shivani Bhardwaj <shivanib134@gmail.com>
To: glen lee <glen.lee@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, tony.cho@atmel.com,
	leo.kim@atmel.com, austin.shin@atmel.com, adel.noureldin@atmel.com,
	adham.abozaeid@atmel.com, Nicolas.FERRE@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 2, 2015 at 7:13 AM, glen lee <glen.lee@atmel.com> wrote:
> Hi Shivani Bhardwaj,
>
> Thank you for the patches.
>
> I am writing this new mail thread since I didn't received about following
> patch which is applied recently.
>
> https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/patch/drivers/staging/wilc1000?id=d4622f68db8095dd54179e3134e97812727f6b89
>
> I have tested this on hardware but it did not working.
> As far as I know, ether_addr_copy function can be used when src and dst
> addresss are __aligned(2) and it has to be proved.
> Would you let us know the addresses are properly aligned? I cannot make sure
> the data is aligned(2).

Hi Glen,

Thanks for pointing out. I checked it. The alignment is wrong. Please
drop this patch. I'm really sorry for the inconvenience caused. I'll
make sure to send a new patch with correct alignment.

Thank you
Shivani

>
> Regards,
> glen lee.
>
