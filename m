Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:37262 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdH1Owc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Aug 2017 10:52:32 -0400
Received: by mail-ua0-f193.google.com with SMTP id 104so320387uas.4
        for <linux-wireless@vger.kernel.org>; Mon, 28 Aug 2017 07:52:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1503912332-4275-1-git-send-email-wright.feng@cypress.com>
References: <1503912332-4275-1-git-send-email-wright.feng@cypress.com>
From: Steve deRosier <derosier@gmail.com>
Date: Mon, 28 Aug 2017 07:52:31 -0700
Message-ID: <CALupW3AWFvGqWDCfvHKkodAMcjf00JrDMHgyuLk3Facg=aqQBA@mail.gmail.com> (sfid-20170828_165236_048621_07D6F30A)
Subject: Re: [PATCH v4] brcmfmac: add CLM download support
To: Wright Feng <wright.feng@cypress.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        kvalo@codeaurora.org, chi-hsien.lin@cypress.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 28, 2017 at 2:25 AM, Wright Feng <wright.feng@cypress.com> wrote:
> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
>
> The firmware for brcmfmac devices includes information regarding
> regulatory constraints. For certain devices this information is kept
> separately in a binary form that needs to be downloaded to the device.
> This patch adds support to download this so-called CLM blob file. It
> uses the same naming scheme as the other firmware files with extension
> of .clm_blob.
>

Not to bikeshed this, but why not just ".clm"?  ".clm_blob" seems
unnecessary and could feel "unprofessional" to users.

To me simple seems better.

- Steve
