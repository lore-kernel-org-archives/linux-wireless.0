Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36043 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753560AbdCGLin (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 06:38:43 -0500
Received: by mail-qk0-f174.google.com with SMTP id 1so202378400qkl.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 Mar 2017 03:38:42 -0800 (PST)
Subject: Re: brcm: firmware for BCM43341 out of date
To: Brennan Ashton <brn@deako.com>
References: <1488683738.26544.4.camel@deako.com>
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <87217bd3-38ce-0c71-863f-170522df1edf@broadcom.com> (sfid-20170307_123947_182449_9D7BF1F5)
Date: Tue, 7 Mar 2017 12:31:59 +0100
MIME-Version: 1.0
In-Reply-To: <1488683738.26544.4.camel@deako.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 5-3-2017 4:15, Brennan Ashton wrote:
> The firmware in the current tree for the BCM43341 hardware seems to
> result in some issues with the 5GHz band.  phy info would show the
> band, but scanning would not return any 5GHz networks. The current
> version in the tree is 6.10.190.49  A newer version (6.10.190.55) was
> released that has been bundled with the android platform. This version
> seemed to resolve the issues that I was having.
> 
> I was not quite sure what the process was for this since I assume that
> the patch needs to be at least signed off by someone from Broadcom.

Not really a process so this will do ;-) I will submit a patch for it
and sign it off. Thanks for the hint. I do not check very often.

Regards,
Arend
