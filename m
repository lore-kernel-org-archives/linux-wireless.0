Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36246 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbbFDPVJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 11:21:09 -0400
Received: by obbqz1 with SMTP id qz1so16564179obb.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2015 08:21:08 -0700 (PDT)
Message-ID: <55706CE1.6040709@lwfinger.net> (sfid-20150604_172113_197794_1A98712E)
Date: Thu, 04 Jun 2015 10:21:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2 2/3] rtlwifi: rtl8192cu: remove INTF_PCI and INTF_USB
References: <1433409093-9134-1-git-send-email-ap420073@gmail.com>
In-Reply-To: <1433409093-9134-1-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/04/2015 04:11 AM, Taehee Yoo wrote:
> in the rtlwifi/rtl8192cu, INTF_PCI and INTF_USB is unnecessary.
> because RTL8192CU chipset is only USB interface.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
> Remove rtlhal to solve warning.

I appreciate your cleanups of this driver, but please compile the source with 
your patch *before* you submit. It is annoying to see V2 in my inbox before I 
have even had a chance to look at V1!

Larry

