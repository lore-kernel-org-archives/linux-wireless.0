Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35632 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab1I3DPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 23:15:44 -0400
Received: by yib18 with SMTP id 18so1145046yib.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2011 20:15:43 -0700 (PDT)
Message-ID: <4E85345D.9080202@lwfinger.net> (sfid-20110930_051548_305434_9258F331)
Date: Thu, 29 Sep 2011 22:15:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Cao, Chongxiao" <ccao1@utk.edu>
CC: "wlanfae@realtek.com" <wlanfae@realtek.com>,
	"chaoming_li@realsil.com.cn" <chaoming_li@realsil.com.cn>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: The Problem of RTL8188ce in Ubuntu 11.04
References: <38894CC285ECBF438599CFCE9811CAB109CFA1FB@CH1PRD0202MB136.namprd02.prod.outlook.com>
In-Reply-To: <38894CC285ECBF438599CFCE9811CAB109CFA1FB@CH1PRD0202MB136.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2011 09:19 PM, Cao, Chongxiao wrote:
> Dear Sir,
>
> I'm a graduate student in University of Tennessee. I just bought the Thinkpad
> T420 laptop that uses the RTL8188CE chipset.
>
> I installed the Ubuntu 11.04. However, my wireless networking is very unstable
> in Ubuntu 11.04. The speed of wireless networking is very slow and it always get
> disconnected in every 2 minutes.
>
> I always do my research projects in Ubuntu so the wireless networking in Ubuntu
> is very important to me.
>
> I have searched on Google to solve this problem and found that lots of people
> have the same problem. I have tried installed the newest driver of RTL8188ce
> from the website of Realtek, but it doesn't work.
>
> Would you please help me deal with this problem? I would appreciate your help.

First of all, not everyone has trouble with rtl8192ce. Neither I nor the Realtek 
group can reproduce the troubles that you describe. Because of that we are not 
able to figure out what people are seeing.

The driver in the standard kernel used in Ubuntu 11.04 has been revised. If 
possible, you should obtain the compat-wireless package built for Ubuntu. If it 
does not exist, then get the compat-wireless source and build the package. That 
will get you the latest set of fixes.

One thing you might try is loading the module with the parameter "ips=0".

Larry
