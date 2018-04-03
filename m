Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:37219 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753156AbeDCTxd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 15:53:33 -0400
Received: by mail-wr0-f176.google.com with SMTP id l49so19850445wrl.4
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 12:53:32 -0700 (PDT)
To: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: License info
Message-ID: <fcdc6adf-6ced-7b0f-9196-e07bf9049e6e@gmail.com> (sfid-20180403_215335_945800_BCE1DD13)
Date: Tue, 3 Apr 2018 21:53:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:

> What is your position regarding license information? Should the standard GPL-V2 
> boiler plate be replaced with "SPDX-License-Identifier: GPL-2.0" in wireless files?

"GPL-2.0" tag is deprecated [0] .


It should be used:
for GNU General Public License v2.0 only:     "GPL-2.0-only"
for GNU General Public License v2.0 or later: "GPL-2.0-or-later"



[0] https://spdx.org/licenses/
    https://www.gnu.org/licenses/identify-licenses-clearly.html
