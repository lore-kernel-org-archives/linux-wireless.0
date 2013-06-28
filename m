Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:56673 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3F1OQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 10:16:56 -0400
Message-ID: <51CD9AD5.5080101@lwfinger.net> (sfid-20130628_161749_001440_A9D22CE2)
Date: Fri, 28 Jun 2013 09:16:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Richard Genoud <richard.genoud@gmail.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: rtl8192cu: slow path warning
References: <20130611123814.GA9854@lnx-rg> <20130626142241.GA13107@lnx-rg> <51CB0E9C.50408@lwfinger.net> <CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com> <51CC8284.9070301@lwfinger.net> <20130628135314.GJ4319@lukather>
In-Reply-To: <20130628135314.GJ4319@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2013 08:53 AM, Maxime Ripard wrote:
> Hi Larry,
>
> On Thu, Jun 27, 2013 at 01:20:52PM -0500, Larry Finger wrote:
>> A revised patch for the warning is attached. The fix relatively
>> simple and the only difference between this one and the earlier
>> version is that routine rtl_lps_change_work_callback() was moved
>> from pci.c to ps.c. As a result, it will be available for ARM and
>> other architectures without a PCI bus.
>
> I just tested it on top of 3.10-rc7 with an imx28, and it works fine.
>
> You can add my
> Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Sorry, I pushed the patch before I read this message, and I missed a Tested-by 
for you. I will wait for any feedback on the patch, and then send a V2.

Thanks for testing.

Larry


