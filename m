Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34702 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbdCNSg5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 14:36:57 -0400
Received: by mail-io0-f174.google.com with SMTP id b140so5505417iof.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Mar 2017 11:36:56 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com. [209.85.223.181])
        by smtp.gmail.com with ESMTPSA id q185sm5530598itc.22.2017.03.14.11.36.55
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Mar 2017 11:36:55 -0700 (PDT)
Received: by mail-io0-f181.google.com with SMTP id f84so5519127ioj.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Mar 2017 11:36:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170314183306.GA55602@google.com>
References: <1487942964-3193-1-git-send-email-akarwar@marvell.com> <20170314183306.GA55602@google.com>
From: Brian Norris <briannorris@chromium.org>
Date: Tue, 14 Mar 2017 11:36:54 -0700
Message-ID: <CA+ASDXPwmW1qZC9CQkj8AP7Fd6pZzSnVJxnFo28R+Nt4xRGEQQ@mail.gmail.com> (sfid-20170314_193659_781405_47430A31)
Subject: Re: [PATCH] mwifiex: fix kernel crash after shutdown command timeout
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Rajat Jain <rajatja@google.com>, dmitry.torokhov@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 14, 2017 at 11:33 AM, Brian Norris <briannorris@chromium.org> wrote:
>
> Hi Amit,
>
> You managed to CC several other Google folks, but not me, the one who
> actually reviewed most of this! You might consider including me in the
> future :)


Oops, in fact you did CC me... my bad. But I usually use my
@chromium.org for this stuff.
