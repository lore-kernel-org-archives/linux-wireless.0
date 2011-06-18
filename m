Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab1FRLQK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 07:16:10 -0400
Subject: Re: iwlagn: Problems with Intel Wifi Link 1000 on newer kernels
From: wwguy <wey-yi.w.guy@intel.com>
To: Erik Hardesty <ehardesty@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTim83iarV-J08JAsVtfLR2ziqLs=iQ@mail.gmail.com>
References: <BANLkTim83iarV-J08JAsVtfLR2ziqLs=iQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Jun 2011 04:12:25 -0700
Message-ID: <1308395545.31756.11.camel@wwguy-ubuntu> (sfid-20110618_131615_147126_2C4F3E45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Erik,

n Thu, 2011-06-16 at 23:14 -0700, Erik Hardesty wrote:
> Having trouble with iwlagn in kernels newer than 2.6.38.
> I've tried 2.6.39 and 3.0rc3 and both give me the same problem.
> I have the latest intel firmware installed on the system. Both
> iwlwifi-1000-3.ucode
> and iwlwifi-1000-5.ucode are in /lib/firmware
> 
> Note: 2.6.38 does not exhibit the same issue and works fine.
> 
> Symptom: Able to scan for access points but unable to connect.
> I am unable to connect to any router regardless of it being open, WEP, or WPAx.
> 
> lspci -v | grep -i wifi:
> 
> 03:00.0 Network controller: Intel Corporation WiFi Link 1000 Series
>     Subsystem: Intel Corporation WiFi Link 1000 Series 1000BGN
> 
> dmesg:
> 
> myhost kernel: wlan0: direct probe to <ap> (try 1)
> myhost kernel: wlan0: direct probe to <ap> (try 2)
> myhost kernel: wlan0: direct probe to <ap> (try 3)
> myhost kernel: wlan0: direct probe to <ap> timed out
> myhost kernel: iwlagn 0000:03:00.0: fail to flush all tx fifo queues
> 
There were a driver split happen to iwlagn between .38 and .39. Could
you please check your .config to make sure all the configuration set
correctly.

I will also need more information on your setup, such as band and
channel, AP model...

One more thing, do you have bluetooth in your system? is it on by
default?

Thanks
Wey

