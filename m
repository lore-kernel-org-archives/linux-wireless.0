Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:44078 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdGVTS0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Jul 2017 15:18:26 -0400
Subject: Re: brcm43430 sdio wifi regression with 4.13-rc1
To: Hans de Goede <hdegoede@redhat.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: russianneuromancer <russianneuromancer@ya.ru>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
References: <d33144fc-c03e-0d71-41b2-e0cd235f5ffa@redhat.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <03779c4f-b48b-444f-59c5-e10324dc77bd@mnementh.co.uk> (sfid-20170722_211831_090675_EC5A3F2E)
Date: Sat, 22 Jul 2017 20:18:23 +0100
MIME-Version: 1.0
In-Reply-To: <d33144fc-c03e-0d71-41b2-e0cd235f5ffa@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/07/17 19:43, Hans de Goede wrote:
> Hi,
> 
> When upgrading my devel environment to 4.13-rc1+ I noticed that
> the brcm43430 sdio wifi on a Chuwi Hi8 plus stopped working:

There is a fix for this:



https://patchwork.kernel.org/patch/9836383/

IIRC

-Ian
