Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34999 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbbFDWxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 18:53:23 -0400
Received: by wgme6 with SMTP id e6so44253025wgm.2
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2015 15:53:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55706CE1.6040709@lwfinger.net>
References: <1433409093-9134-1-git-send-email-ap420073@gmail.com>
	<55706CE1.6040709@lwfinger.net>
Date: Fri, 5 Jun 2015 07:53:22 +0900
Message-ID: <CAMArcTUF0vxz0o3tQs67pXe_nK-xuU4C2eDJbguZfonQew91bA@mail.gmail.com> (sfid-20150605_005327_836670_A30F6F76)
Subject: Re: [PATCH V2 2/3] rtlwifi: rtl8192cu: remove INTF_PCI and INTF_USB
From: Taehee Yoo <ap420073@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-06-05 0:21 GMT+09:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 06/04/2015 04:11 AM, Taehee Yoo wrote:
>>
>> in the rtlwifi/rtl8192cu, INTF_PCI and INTF_USB is unnecessary.
>> because RTL8192CU chipset is only USB interface.
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>> ---
>> Remove rtlhal to solve warning.
>
>
> I appreciate your cleanups of this driver, but please compile the source
> with your patch *before* you submit. It is annoying to see V2 in my inbox
> before I have even had a chance to look at V1!
>
> Larry
>

Apologize for my mistake. and Thank you for your feedback!
