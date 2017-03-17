Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:34980 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdCQISj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 04:18:39 -0400
Received: by mail-qt0-f181.google.com with SMTP id x35so56803071qtc.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Mar 2017 01:18:07 -0700 (PDT)
Subject: Re: Fw: [Bug 194903] New: After updating Kernel to 4.9.9 my wireless
 adapter does not work
To: Stephen Hemminger <stephen@networkplumber.org>,
        linux-wireless@vger.kernel.org
References: <20170316224743.2723cf14@xeon-e3>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6932c361-4ca1-8d81-3e32-2bee1b62dd81@broadcom.com> (sfid-20170317_091941_987969_A18FCD73)
Date: Fri, 17 Mar 2017 09:18:02 +0100
MIME-Version: 1.0
In-Reply-To: <20170316224743.2723cf14@xeon-e3>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-3-2017 6:47, Stephen Hemminger wrote:
> 

Hi Stephen,

The issue here is with an out-of-tree driver, ie. broadcom-wl, so not
really a kernel issue. Anyway, I asked for more info in bugzilla to
determine whether using the brcmfmac driver, which is supported
upstream, is an option.

Regards,
Arend

> Begin forwarded message:
> 
> Date: Fri, 17 Mar 2017 02:22:58 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 194903] New: After updating Kernel to 4.9.9 my wireless adapter does not work
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=194903
> 
>             Bug ID: 194903
>            Summary: After updating Kernel to 4.9.9 my wireless adapter
>                     does not work
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 4.9.9
>           Hardware: x86-64
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: blocking
>           Priority: P1
>          Component: IPV4
>           Assignee: stephen@networkplumber.org
>           Reporter: jemel.robinson@icloud.com
>         Regression: No
> 
> I have a Macbook Pro 13" (7, 1) and when I updated my kernel version to 4.9.9
> (F25), my broadcom wireless adapter is no longer detected. I have since updated
> to the latest kernel and have gotten the same result. As of now, I am currently
> operating at the kernel version prior to 4.9.9 (4.8.6-300.fc25.x86_64
> ) and I am able to use WiFi with no issues. I have tried uninstalling and
> reinstalling the broadcom -wl driver to no avail. I narrowed the issue down to
> the kernel simply by updating the kernel only and after reboot, wireless was
> gone.
> 
