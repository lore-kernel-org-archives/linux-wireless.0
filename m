Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:33887 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753536AbdKRFGv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Nov 2017 00:06:51 -0500
Received: by mail-pg0-f46.google.com with SMTP id 4so3462888pge.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Nov 2017 21:06:51 -0800 (PST)
Message-ID: <1510981609.5145.0.camel@gmail.com> (sfid-20171118_060656_802004_386EDE85)
Subject: Re: rtl8723be on Fedora27
From: rosenp@gmail.com
To: =?ISO-8859-1?Q?R=E1kosi?= Gergely <rakosi.gergely@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Fri, 17 Nov 2017 21:06:49 -0800
In-Reply-To: <f5876284-360c-e6bf-01c8-ed95c4298647@gmail.com>
References: <f5876284-360c-e6bf-01c8-ed95c4298647@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-11-17 at 09:16 +0100, Rákosi Gergely wrote:
> Hello,
> 
> I'm trying to use rtl8723be wifi on Fedora27 but I still get
> continuosly
> disconnection. The error in the dmesg is "Init MAC failed"
> I tried with the following module options too : "fwlps=0 swlps=0" and
> the variant of "ant_sel=1 or 2 or 0"
> I downloaded the git files from your repo, and do the usual make,make
> install, and modprobe stuffs, and then restart the notebook, but I
> get
> the same result.
> 

Could try blacklisting rtlwifi. That way it uses rtl8xxxu.
> Thanks your help,
> Regards,
> Gergely
