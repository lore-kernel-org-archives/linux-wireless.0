Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32931 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab1COTMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 15:12:37 -0400
Received: by vws1 with SMTP id 1so889301vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 12:12:36 -0700 (PDT)
Message-ID: <4D7FBA20.1050609@lwfinger.net>
Date: Tue, 15 Mar 2011 14:12:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org,
	=?ISO-8859-1?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
Subject: Re: [RFC/RFT 0/11] rtlwifi: rtl8192se: Merge new driver
References: <4d732b50.jiYdcLhAW6PZf7C3%Larry.Finger@lwfinger.net> <20110314200214.GC2525@tuxdriver.com>
In-Reply-To: <20110314200214.GC2525@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/14/2011 03:02 PM, John W. Linville wrote:
> On Sun, Mar 06, 2011 at 12:36:00AM -0600, Larry Finger wrote:
>> This set of patches merges a new driver for the RTL8192SE device.
>>
>>   1/11: rtlwifi: rtl8192se: Merge routines for dynamic management
>>   2/11: rtlwifi: rtl8192se: Merge routines for firmware loading
>>   3/11: rtlwifi: rtl8192se: Merge routines for device specific hardware access
>>   4/11: rtlwifi: rtl8192se: Merge routines for LED handling
>>   5/11: rtlwifi: rtl8192se: Merge routines for PHY handling
>>   6/11: rtlwifi: rtl8192se: Merge register definition routine
>>   7/11: rtlwifi: rtl8192se: Merge routines for RF handling
>>   8/11: rtlwifi: rtl8192se: Merge routines for initialization
>>   9/11: rtlwifi: rtl8192se: Merge routines for tables
>> 10/11: rtlwifi: rtl8192se: Merge routines for TX and RX
>> 11/11: rtlwifi: rtl8192se: Modify rtlwifi routines to handle rtl8192se add Makefile and Kconfig
>> ---
>>
>> John,
>>
>> This driver is the one you asked about a couple of days ago. If possible to get this in
>> 2.6.39, please do so.
>>
>> Larry
>
> This driver looks acceptable (certainly better than no driver),
> but patch 11 (v2) doesn't seem to apply.  Did you get a
> resolution to the problems reported by François Valenduc
> <francois.valenduc@tvcablenet.be>?

Yes, those problems are resolved.

I will be submitting it soon as it is better than no driver. Chaoming just sent 
me some new revisions that I would like to integrate first.

It will be sent soon so as to get it into 2.6.40 - .39 was too much of a push.

Larry
