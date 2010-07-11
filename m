Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:54016 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822Ab0GKGEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 02:04:52 -0400
Received: from Philip-Prindevilles-MacBook-Pro.local ([192.168.1.114])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.4/8.14.4) with ESMTP id o6B64pWU018178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 00:04:51 -0600
Message-ID: <4C395F03.40200@redfish-solutions.com>
Date: Sun, 11 Jul 2010 00:04:51 -0600
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Ath5k breaking in ath5k_pci_suspend_compat going on 2 weeks
References: <4C3926F7.5070606@redfish-solutions.com>
In-Reply-To: <4C3926F7.5070606@redfish-solutions.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I take it back... it seems to go back at least to 2010-06-12.


On 7/10/10 8:05 PM, Philip Prindeville wrote:
> This still seems to be broken, a couple of weeks later:
>
>   CC [M]  
> /home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/attach.o 
>
>   CC [M]  
> /home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/base.o 
>
> /home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/base.c:243: 
> error: 'ath5k_pci_suspend_compat' undeclared here (not in a function)
> /home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/base.c:244: 
> error: 'ath5k_pci_resume_compat' undeclared here (not in a function)
> make[6]: *** 
> [/home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/base.o] 
> Error 1
> make[5]: *** 
> [/home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k] 
> Error 2
> make[4]: *** 
> [/home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath] 
> Error 2
> make[3]: *** 
> [/home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless] 
> Error 2
>
>
> and from today's tarball:
>
>
>   CC [M]  
> /home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k/base.o 
>
> /home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k/base.c:243: 
> error: 'ath5k_pci_suspend_compat' undeclared here (not in a function)
> /home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k/base.c:244: 
> error: 'ath5k_pci_resume_compat' undeclared here (not in a function)
> make[6]: *** 
> [/home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k/base.o] 
> Error 1
> make[5]: *** 
> [/home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k] 
> Error 2
> make[4]: *** 
> [/home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath] 
> Error 2
> make[3]: *** 
> [/home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless] 
> Error 2
>
>
> Can someone please have a look and fix their regression?
>
> Thanks,
>
> -Philip

