Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:39021 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbdK3K5u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Nov 2017 05:57:50 -0500
Received: by mail-qt0-f181.google.com with SMTP id k19so8155492qtj.6
        for <linux-wireless@vger.kernel.org>; Thu, 30 Nov 2017 02:57:50 -0800 (PST)
Subject: Re: [EXT] Marvell Mwifiex wireless driver: mwifiex_pcie broken on
 Marvell ESPRESSOBin
From: Ellie Reeves <ellierevves@gmail.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
References: <6dc0221c-c7ec-d107-02e8-0ab443807e51@gmail.com>
 <a4233e0d08f1400fa30ef112e0fda464@SC-EXCH02.marvell.com>
 <7d8c7705-70ac-9a36-b5d2-23fcffcf6a29@gmail.com>
 <4dbd89bbcb0a4706bf3fe7b79025d95c@SC-EXCH02.marvell.com>
 <6e26f5b1-10a7-b7fc-1518-f0d0f66a50e9@gmail.com>
Message-ID: <44a8b2b8-d798-0e5d-0da1-c2bea52463bc@gmail.com> (sfid-20171130_115755_058786_E73661DB)
Date: Thu, 30 Nov 2017 05:57:33 -0500
MIME-Version: 1.0
In-Reply-To: <6e26f5b1-10a7-b7fc-1518-f0d0f66a50e9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,
I tried the few patch that made it to this list without any real 
success... I suppose the issue isn't that easy to reproduce on your side 
so... Shall I try a git bisect, building only that module and see if I 
can narrow it down a bit ? I'm no expert with git or git bisect for that 
matter, but I'm guessing building the module will be less time consuming 
than building the entire kernel... Unless you want me to do something 
else to help in debugging. I want to help as much as I can to solve 
this, heh, even despite me annoying my father because his wifi access 
point goes poof. :)
Thanks,

-- 
Ellie Reeves
