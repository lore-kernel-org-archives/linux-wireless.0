Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36619 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdHVTle (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 15:41:34 -0400
Received: by mail-wm0-f52.google.com with SMTP id z132so1005357wmg.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Aug 2017 12:41:33 -0700 (PDT)
Subject: Re: [PATCH v5] brcmfmac cleanup
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0e3ce8c6-6a4c-b6dc-be20-47be1566aa50@broadcom.com> (sfid-20170822_214136_903486_E44EE4E9)
Date: Tue, 22 Aug 2017 21:41:31 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> Hi folks,
> 
> Arend, as requested - a respin to take account of your comments.
> 
> Unfortunately, although I've only included the patches you requested from v4,
> breaking out some of the simpler changes (whitespace, macos, etc.) has grown
> the set back up to 30 patches. I hope this is OK.

:-( Grumbl, you also introduced some new ideas, eg. patch 26/30. I 
reviewed 15 patches that mostly involved in cleaning up bcmsdh.c. My 
hopes were that you addressed those 15 patches with a respin to get that 
part at least in for 4.14 as we are steadily moving towards the merge 
window. Maybe you did, but going from 15 to 30 feels like things are 
moving in the wrong direction. I will dig through it again.

Regards,
Arend
