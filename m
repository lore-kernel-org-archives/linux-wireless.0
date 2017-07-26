Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.phoenitydawn.de ([213.202.223.74]:50449 "EHLO
        mail.phoenitydawn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdGZNem (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 09:34:42 -0400
From: Daniel Roschka <danielroschka@phoenitydawn.de>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: brcmfmac: BCM43602 in Touch Bar MacBook Pros not working properly
Date: Wed, 26 Jul 2017 15:35:01 +0200
Message-ID: <1582685.24dAe2tvLm@buzzard> (sfid-20170726_153446_711247_826F4187)
In-Reply-To: <597881DF.4050609@broadcom.com>
References: <2355211.moJg6pnjHJ@buzzard> <597881DF.4050609@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, 26. July 2017, 13:49:51 CEST you wrote:
> So if possible please do:
> 
> $ insmod brcmfmac debug=0xd416

You'll find the log attached to the bugzilla report:
https://bugzilla.kernel.org/show_bug.cgi?id=193121#c8

If there's anything else I can provide to get to the ground of this issue, I'm 
happy to do so.

Daniel
