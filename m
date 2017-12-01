Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:37077 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751254AbdLAPh3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 10:37:29 -0500
Received: by mail-qk0-f176.google.com with SMTP id i130so13625953qke.4
        for <linux-wireless@vger.kernel.org>; Fri, 01 Dec 2017 07:37:29 -0800 (PST)
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
 <44a8b2b8-d798-0e5d-0da1-c2bea52463bc@gmail.com>
Message-ID: <0c5acf38-d634-12b6-9f0d-0ae8c6535558@gmail.com> (sfid-20171201_163738_938701_6AF96F01)
Date: Fri, 1 Dec 2017 10:37:14 -0500
MIME-Version: 1.0
In-Reply-To: <44a8b2b8-d798-0e5d-0da1-c2bea52463bc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
just a short message to mention I booted the 4.14 kernel and grabbed 
what was in /sys/class/devcoredump/devcd1/data into a file. I'm not sure 
if it could be useful, but did it anyways... Let me know if it's useful 
and I'll post the binary somewhere.
Thanks

-------- Message original --------
> Hi again,
> I tried the few patch that made it to this list without any real 
> success... I suppose the issue isn't that easy to reproduce on your 
> side so... Shall I try a git bisect, building only that module and see 
> if I can narrow it down a bit ? I'm no expert with git or git bisect 
> for that matter, but I'm guessing building the module will be less 
> time consuming than building the entire kernel... Unless you want me 
> to do something else to help in debugging. I want to help as much as I 
> can to solve this, heh, even despite me annoying my father because his 
> wifi access point goes poof. :)
> Thanks,
>

-- 
Ellie Reeves
