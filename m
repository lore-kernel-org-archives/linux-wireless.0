Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34553 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdHAEzx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 00:55:53 -0400
Received: by mail-io0-f180.google.com with SMTP id o9so3906650iod.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jul 2017 21:55:52 -0700 (PDT)
MIME-Version: 1.0
From: George H <ghh19622@gmail.com>
Date: Tue, 1 Aug 2017 14:55:52 +1000
Message-ID: <CAG5S3ZQxCXFSPpxBqTc+ysyVxodR6E8ue2uxxjcuVNzmhF_zyA@mail.gmail.com> (sfid-20170801_065558_819912_61F704D0)
Subject: Re: Problem seen with wireless mesh
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michel,

I didn't have SAE authentication enabled, it was open mode. The latest
logs give some clues. The mesh appears to have gone down and this is
possibly the reason for the ping failure. After a while, the mesh
discovery starts again and restores the mesh. On product B, I see the
dropped_frames_no_route statistic incrementing during the period of
ping failure. I'm investigating why the mesh became inactive.

Thanks for your response.
