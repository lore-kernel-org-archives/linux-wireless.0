Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34426 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448AbbGHPTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 11:19:40 -0400
Received: by oiab3 with SMTP id b3so49902255oia.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jul 2015 08:19:39 -0700 (PDT)
Message-ID: <559D3F89.9000404@lwfinger.net> (sfid-20150708_171950_422691_04E20642)
Date: Wed, 08 Jul 2015 10:19:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Binderman <dcb314@hotmail.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-4.2-rc1/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c:2183:
 bad expression ?
References: <DUB128-W77C11FFEB09B442BD8C9229C910@phx.gbl>
In-Reply-To: <DUB128-W77C11FFEB09B442BD8C9229C910@phx.gbl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/2015 03:41 AM, David Binderman wrote:
> Hello there,
>
> [linux-4.2-rc1/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c:2183]: (style) Expression '(X & 0xfc) == 0x3' is always false.
>
> Source code is
>
>     if ((bt_msr & 0xfc) == MSR_AP)

Thanks for the report. A fix was just submitted listing you as the Reporter.

Larry


