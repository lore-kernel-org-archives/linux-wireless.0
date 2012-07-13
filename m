Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41797 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653Ab2GMMcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 08:32:25 -0400
Received: by gglu4 with SMTP id u4so3485479ggl.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2012 05:32:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF60B53.4070603@lwfinger.net>
References: <CAJrANNJutyjAUPeQsLK4M30oe0PqArHJUVeJKUUJ6GExSEv6Eg@mail.gmail.com>
	<4FF60B53.4070603@lwfinger.net>
Date: Fri, 13 Jul 2012 13:32:24 +0100
Message-ID: <CAJrANNLNUXue-FSuu+QTT9vwFrokKsrjJAKcTNvcr4mAm_NDpw@mail.gmail.com> (sfid-20120713_143230_079449_0FC91601)
Subject: Re: PROBLEM: RTL8192CU / TRENDnet TEW-648UBM V1.1 USB Wireless
From: David Moore <spasysheep@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 5, 2012 at 10:46 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 07/05/2012 04:34 PM, David Moore wrote:
>>
>> - TRENDware/TRENDnet TEW-648UBM V1.1 USB Wireless doesn't work properly
>> - Driver (RTL8192CU) loads, device appears to work, but will not pick
>> up most networks and will not connect to any. Fails with bad
>> passphrase if connected through Wicd or DHCPCD times out waiting for
>> carrier carrier if connected manually (WPA2-PSK)
>> - Linux version 3.4.4-2-ARCH (tobias@T-POWA-LX) (gcc version 4.7.1
>> (GCC) ) #1 SMP PREEMPT Sun Jun 24 18:59:47 CEST 2012
>> - Recreated by trying to connect to wireless networks with TEW-648UBM V1.1
>> - http://www.wikidevi.com/wiki/TRENDnet_TEW-648UBM
>> - http://ubuntuforums.org/showthread.php?t=1667682
>
>
> Does the attached patch help?
>
> Larry
>

No, it doesn't seem to change anything
