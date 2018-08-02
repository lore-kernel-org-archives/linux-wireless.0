Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:39825 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730038AbeHBDlD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 23:41:03 -0400
Received: by mail-yw0-f182.google.com with SMTP id r184-v6so236794ywg.6
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2018 18:52:21 -0700 (PDT)
MIME-Version: 1.0
From: Joshua Zhao <swzhao@gmail.com>
Date: Wed, 1 Aug 2018 18:52:20 -0700
Message-ID: <CAKmTU=p=HBNYiNmEhoUJVhZpuYrrFMjhfxkO0fegOTu8pjuSxg@mail.gmail.com> (sfid-20180802_035225_053361_FAA7C14E)
Subject: 11s mesh authentication problem
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I'm running the open source 11s mesh with QCA Dakota radios. But as we
set up more spaces, say > 4 spaces, mesh authentication starts to
become difficult. As I look into the code, it appears to me that the
SAE state machine is not tracking/identifying the peers?  So when the
commit & confirm messages between multiple peers interleave each
other, the state machine either sees ECC/FFC mismatch or keeps
resetting the states.

Is my observation correct?  And is this a known issue?

Thanks,
Joshua
