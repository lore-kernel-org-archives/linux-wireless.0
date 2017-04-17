Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34186 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757211AbdDQBLe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 21:11:34 -0400
Received: by mail-oi0-f47.google.com with SMTP id x184so41731843oia.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 18:11:33 -0700 (PDT)
Subject: Re: RTL8821AE 802.11ac problem after kernel upgrade
To: hamed <hmahmoud1288@gmail.com>, linux-wireless@vger.kernel.org
References: <4b32be10-a3fe-da9d-5832-a89fdb53eb13@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <7c31686a-a5e3-1fe1-86f5-b32487390269@lwfinger.net> (sfid-20170417_031145_232944_A923CCC3)
Date: Sun, 16 Apr 2017 20:11:32 -0500
MIME-Version: 1.0
In-Reply-To: <4b32be10-a3fe-da9d-5832-a89fdb53eb13@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2017 07:48 PM, hamed wrote:
> hi,
>
> my wifi works well on kernel version " 4.9.13-200.fc25.x86_64" , but it
> become so unstable & keeps disconnecting frequently if i use newer
> kernels , i sent attachments  & i hope i can be useful in solving such
> problem , thanks for your concern.

Hamed,

 From your report, the problem occurred between kernel 4.9.13 and 4.9.14. 
Unfortunately, there were no changes in the kernel.org repos that would affect 
the RTL8821AE. It is possible that Fedora made some change that is not present 
at kernel.org, but I find that unlikely.

Did anything else on your system change? In addition, you should post an excerpt 
of the dmesg log that shows the nature of the disconnect.

Larry
