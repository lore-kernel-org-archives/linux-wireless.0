Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:62933 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278Ab3HNDEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 23:04:36 -0400
Received: by mail-oa0-f42.google.com with SMTP id i18so12631774oag.15
        for <linux-wireless@vger.kernel.org>; Tue, 13 Aug 2013 20:04:35 -0700 (PDT)
Message-ID: <520AF3BD.5020705@lwfinger.net> (sfid-20130814_050439_528819_4769A29F)
Date: Tue, 13 Aug 2013 22:04:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Colleen Josephson <cjoseph@mit.edu>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: issues with RTL8188CE device and rtl8192ce driver
References: <CAN3-2D7=P=9VyV7xoANw_6B8VhOaTRC1iMw+mwUH2-g8YOmPMg@mail.gmail.com> <520968B0.80301@lwfinger.net> <CAN3-2D5rCnXYogA6s6in_e6qpyLmZ0bpbGX=REi=Cn29U40nMw@mail.gmail.com> <520971BA.6040503@lwfinger.net> <CAN3-2D75TLTS-Fv3CgoBjA+RA3jv-QyLoSs+PZeKXLY_MUcSTQ@mail.gmail.com> <520975D8.8040908@lwfinger.net> <CAN3-2D6KSsFXQ5QOGfp-1c69dCSrCEdcgXMfPcuEC+Hx_dX_zw@mail.gmail.com>
In-Reply-To: <CAN3-2D6KSsFXQ5QOGfp-1c69dCSrCEdcgXMfPcuEC+Hx_dX_zw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2013 07:08 PM, Colleen Josephson wrote:
> After making the bultins into modules, the compat drivers are loaded and used.
>
> Unfortunately, the same symptoms as my original e-mail persist, with
> repeated deauthentication (reason=3).
>
> I am using backports-3.11-rc3-1

That should be the same driver as the one I am using.

First, what chip is in your computer. Please send me the output of the command 
'/sbin/lspci -nnv'. Only the stanza for the RTL8188CE will be needed. There are 
at least 4 different chips that work with driver rtl8192ce.

Second, what is the make/model of the access point that you are using? Is the 
firmware up to date?

Third, what is the encryption method you are using, and what is the maximum rate 
for the connection? That will tell me if you are using 802.11g or 802.11n.

Larry


