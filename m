Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:27497 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYB0OiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 09:38:25 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3235136wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2008 06:38:24 -0800 (PST)
Message-ID: <c74ac3520802270638m7674c0fbh5f509fe0c5e5d566@mail.gmail.com> (sfid-20080227_143842_333475_5104757B)
Date: Wed, 27 Feb 2008 16:38:24 +0200
From: "Elyahou ITTAH" <ittah.elyahou@gmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Compiler error when compile iwlwifi
In-Reply-To: <D936D925018D154694D8A362EEB0892003C36D06@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c74ac3520802260339p7fd58501rbd967e755f4eaee6@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892003C36C47@orsmsx416.amr.corp.intel.com>
	 <c74ac3520802270146q697f3da8m238372c4c88ed691@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892003C36D06@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/27, Chatre, Reinette <reinette.chatre@intel.com>:
> On Wednesday, February 27, 2008 1:46 AM, Elyahou ITTAH  wrote:
>
>  > 2008/2/27, Chatre, Reinette <reinette.chatre@intel.com>:
>  >> On , Elyahou ITTAH  wrote:
>  >>
>  >>  > Hi,
>  >>  >
>  >>  > When i try to compile the iwlwifi driver I have got this error:
>  >>  > http://rafb.net/p/UdH56R87.html
>  >>  >
>  >>
>  >>> I have a 2.6.24-r2 gentoo kernel,with the iwlwifi included... -
>  >>
>  >>> To unsubscribe from this list: send the line "unsubscribe
>  >>  > linux-wireless" in the body of a message to
>  >>  majordomo@vger.kernel.org > More majordomo info at
>  >> http://vger.kernel.org/majordomo-info.html
>  >>
>  >>
>  >> The iwlwifi driver development is now focused on upstream so
>  >>  backporting of the intellinuxwireless.org drivers are only done for
>  >> kernels
>  >>  2.6.18-2.6.23. The easiest way to use the latest driver with your
>  >>  kernel will be to use the compat-wireless project
>  >>  (http://linuxwireless.org/en/users/Download).
>  >>
>  >>
>  >>  Reinette
>  >>
>  >
>  > Apologize
>  > I misunderstood the last answer...
>  >
>  > So I have to wait know the support for the new kernel... :)
>  >
>  > I don't wan't to downgrade it..
>
>
> No need to downgrade your kernel or the driver. You can use the latest
>  iwlwifi driver available with your current (2.6.24-rc2 gentoo) kernel
>  when you make use of the compat-wireless project.
>
>
>  Reinette
>

Thx,

But i tried few days ago with the compat tool and i receive en error...

Here's my previous message:

I have modified my config file : http://rafb.net/p/SfeJHk39.html

I have now compiled the driver, and reboot my PC ( I can't make unload
because unloading my iwl3945 module causes a kernel panic -that is why
I upgrade the driver)

After the reboot the module can't be loaded... : http://rafb.net/p/FLQeJV50.html

Thx
