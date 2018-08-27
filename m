Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35133 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbeH0TPz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 15:15:55 -0400
Received: by mail-oi0-f45.google.com with SMTP id m11-v6so28015733oic.2
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2018 08:28:50 -0700 (PDT)
Subject: Re: [Regression]BCM4312 is broken in kernel 4.18[Root cause found]
To: prabhu <d.praabhu@gmail.com>
Cc: kabe@sra-tohoku.co.jp, kvalo@codeaurora.org, m@bues.ch,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
References: <CAHnrWRruLuuPN+bYc4NqO515W8+wHoCPH16ULsnJV_JrD+9oEw@mail.gmail.com>
 <20180823201147.393b1d53@wiggum> <87lg8wjhqe.fsf@kamboji.qca.qualcomm.com>
 <f9553dfe-d89b-0760-29c6-cdad29b54f6f@lwfinger.net>
 <CAHnrWRp2n7W_Xb5kjT1ykcC0gL3ONc+dmqePAbKEEBHLd1euFA@mail.gmail.com>
 <25814b23-dcc9-3a20-7276-40818bbba6cb@lwfinger.net>
 <CAHnrWRo-Edm+bSJ_1EKNYkPR2zKVnvfoTpaLK+uY1bw4JS7ZjQ@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <0ce95ac6-1271-c9d5-b48a-4612ad04f51d@lwfinger.net> (sfid-20180827_172853_615395_ECDB9F7B)
Date: Mon, 27 Aug 2018 10:28:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAHnrWRo-Edm+bSJ_1EKNYkPR2zKVnvfoTpaLK+uY1bw4JS7ZjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/27/2018 06:30 AM, prabhu wrote:
> Larry,
> 
> Applied on a clean 4.18.4 source and tested.
> It works for me.

Thanks for testing. I will push the patch upstream.

Larry
