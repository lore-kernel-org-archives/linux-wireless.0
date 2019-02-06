Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E46C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 12:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7523E20B1F
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 12:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbfBFMaF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 07:30:05 -0500
Received: from [195.159.176.226] ([195.159.176.226]:45068 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbfBFMaF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 07:30:05 -0500
Received: from list by blaine.gmane.org with local (Exim 4.89)
        (envelope-from <glkwg-linux-wireless-2@m.gmane.org>)
        id 1grML4-0010l8-DM
        for linux-wireless@vger.kernel.org; Wed, 06 Feb 2019 13:30:02 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-wireless@vger.kernel.org
From:   Ferry Toth <ftoth@telfort.nl>
Subject: Re: Driver for RealTek RTL8811AU dual-band USB WiFi adapter
Date:   Wed, 6 Feb 2019 13:25:42 +0100
Message-ID: <ac86d561-83bf-1364-86b7-bb8f54c4f98f@telfort.nl>
References: <fed00b53-2468-55ea-fa98-0a324a469075@gmail.com>
 <211805b1-7f4a-59ea-508a-3c56ef7f0803@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
In-Reply-To: <211805b1-7f4a-59ea-508a-3c56ef7f0803@lwfinger.net>
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Op 04-11-18 om 17:52 schreef Larry Finger:
> On 11/4/18 9:43 AM, Chris Ward wrote:
>> I recently bought one of these 
>> https://www.amazon.co.uk/gp/product/B07C4JQZSP/ref=oh_aui_detailpage_o01_s01?ie=UTF8&psc=1 
>> ;
>> a dual-band wifi adapter. It came with source for a Linux driver, 
>> which required some patching to get it to work with the
>> 4.19 kernel. Can I interest a kernel developer to integrate this into 
>> kernel.org ? It would save me
>> effort at further patching if someone else kept it current as the 
>> kernel changes.
>>
>> The driver from Amazon is here 
>> https://drive.google.com/open?id=1AYmjFk2l5jTpnAzLPNpetSGefm4khEBi
>> and my patch is here 
>> http://tjcw.freeshell.org/Patches/rawhide-20181031.patch .
>>
>> The Amazon driver is stated to be GPL, and I am content for my work to 
>> be GPL also.
>>
>> If you need further information, please email me (tjcw at cantab.net)
> 
> Even though the driver is GPL, it would take roughly 6 months for an 
> experienced kernel coder to rewrite the crappy code that Realtek 
> provides, particularly for its USB devices, to get it into a form that 
> would be accepted into the kernel. If you are offering $10K for the 
> project, you might get some interest. :)
> 
> As I offer a number of USB drivers for Realtek USB devices at GitHub, 
> and I keep them patched for changes in the kernel API, I might consider 
> adding this one to the collection there. It would be useful if someone 
> would provide me with a sample device. Without that, I would rely on 
> remote testing. A quick look at your patches indicate that you are 
> destroying the ability to build the driver on earlier kernels. That is 
> what is done for in-kernel code, but for an external driver one needs to 
> keep a lot of flexibility.
> 
> Larry
> 
Do I understand correct that the kernel 8821ae also supports 8812? Is 
that not close to 8811?

We found a 8811AU based dongle on Ali Express for €7. I'd be happy to 
make sure you get one.

