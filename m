Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mirapoint21.brutele.be ([212.68.199.158]:39697 "EHLO
	mirapoint21.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab1COWAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 18:00:18 -0400
Message-ID: <4D7FE15C.4090409@tvcablenet.be>
Date: Tue, 15 Mar 2011 22:59:56 +0100
From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT 0/11] rtlwifi: rtl8192se: Merge new driver
References: <4d732b50.jiYdcLhAW6PZf7C3%Larry.Finger@lwfinger.net> <20110314200214.GC2525@tuxdriver.com> <4D7FBA20.1050609@lwfinger.net> <20110315192337.GC2542@tuxdriver.com> <4D7FC684.8090505@tvcablenet.be> <4D7FD43C.7040705@lwfinger.net>
In-Reply-To: <4D7FD43C.7040705@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 15/03/11 22:03, Larry Finger a écrit :
> On 03/15/2011 03:05 PM, François Valenduc wrote:
>> Thanks for your efforts. However, even if I managed to compile this
>> driver, it doesn't detect my wifi card. So, I hope this new version will
>> solve this problem.
>
> I certainly don't understand that part. Your PCI ID (10ec:8172)
> exactly matches one of the cards I have.
>
> Larry
>
I probably did something wrong when I tested this driver last week. In
fact, the rtl8192se module is well automatically loaded. I think the
problem is related to the firmware. I found the following lines in dmesg:

[  411.306526] rtl8192se 0000:06:00.0: setting latency timer to 64
[  411.324081] rtl8192se:rtl92s_init_sw_vars():<0-0> Failed to request
firmware!
[  411.324086] rtlwifi:rtl_pci_probe():<0-0> Can't init_sw_vars.
[  411.324126] rtl8192se 0000:06:00.0: PCI INT A disabled

I am using the firmware provided by realtek on this webpage:
http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=21&PFid=48&Level=5&Conn=4&DownTypeID=3&GetDown=false&Downloads=true
It seems I should use another one ? If so, where can I find it ?

Thanks for your help.
François
