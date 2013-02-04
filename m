Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:37429 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3BDPyr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:54:47 -0500
Received: by mail-ie0-f169.google.com with SMTP id 13so3961103iea.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2013 07:54:46 -0800 (PST)
Message-ID: <510FD9A6.2080908@gmail.com> (sfid-20130204_165451_244575_4DF25B86)
Date: Mon, 04 Feb 2013 10:54:14 -0500
From: Dylan <dylandonkersgoed@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8723ae Weak Signal Problems
References: <51072B15.2030805@gmail.com> <51072B95.10101@gmail.com> <51080904.5000103@lwfinger.net> <51095E55.3020106@gmail.com> <510982FA.3010401@lwfinger.net>
In-Reply-To: <510982FA.3010401@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2013 03:30 PM, Larry Finger wrote:
> On 01/30/2013 11:54 AM, Dylan wrote:
>
> Please do not drop the Cc to wireless.
>
>> I apologize for the late response and limited information.
>>
>> The patch doesn't work for me - same problems as before, i.e. the 
>> patch doesn't
>> seem to have changed anything. I attached a log. I expect you can 
>> make more
>> sense of it than I.
>>
>> I can give you the model number of only one of the router/access 
>> points - the
>> Cisco DPC3825 which I have. Unfortunately I can't offer much analysis 
>> of it as
>> it's in modem only mode now and it's not very practical to reactivate 
>> it as an
>> access point at this time. I could try to find out what my school is 
>> using as well.
>>
>> I've noticed that with the compat wireless drivers I'm ALSO 
>> experiencing similar
>> problems with an RTL8188CU card. I expect that's relevant. Funnily 
>> enough I have
>> three wireless cards on hand and all of them are some form of Realtek 
>> card.
>
> The vendor driver you are using, 
> /rtl_92ce_92se_92de_8723ae_linux_mac80211_0006.0514.2012/, is 
> relatively old. My patches were for 
> rtl_92ce_92se_92de_8723ae_88ee_linux_mac80211_0010.0109.2013, however, 
> since I wrote earlier, I found 
> rtl_92ce_92se_92de_8723ae_88ee_linux_mac80211_0011.0128.2013, which 
> you will find on the Realtek web site under the RTL8188CE listing for 
> Linux. That one includes my feedback to Realtek about the 01092013 
> version, and it should build on mainline kernels through 3.8, but not 
> the current wireless-testing, but I doubt that you are using that 
> tree. With that driver, my RTL8723AE got throughput of 60-70 Mbps for 
> both RX and TX. I did have an unexplained kernel panic while running 
> that driver, thus there might be a severe bug in it. I don't know if 
> it is rtl8723e, but that is the only panic that I have had with 3.8-rc4.
>
> The driver for the RTL8188CU/RTL8192CU is a mess. Unfortunately, I am 
> not getting musch help from Realtek. For that reason, I am 
> concentrating on the CE models. Their PCIe group is more responsive.
>
> Larry
>
Sorry, just used to hitting Reply and NOT Reply All. It seems possible 
that the problem may in fact be with the router. Or partially with the 
router anyway. I DO have weak signal problems with the rtl8723ae Linux 
drivers and always have but they may not be any worse than they were 
before. One of my roommates is having trouble as well (though everyone 
else using the router is fine as far as I can tell). I've noticed from 
diagnostics with the router that most clients seem to be getting a ping 
of about 6ms with occasional spikes, which seems a bit odd (I've 
generally had pings of about 2ms with my own routers when I've checked 
in the past) but I don't think it's necessarily anything to worry about. 
I'll e-mail again if I can confirm with any certainty that it's either 
the router or the wireless drivers.
