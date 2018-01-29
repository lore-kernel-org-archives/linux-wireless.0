Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55468 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751257AbeA2SlL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 13:41:11 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Tobias Schramm <tobleminer@gmail.com>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] pci: Add vendor id of Ubiquiti Networks
References: <20180125111340.17553-1-tobleminer@gmail.com>
        <20180125111340.17553-2-tobleminer@gmail.com>
        <20180129180349.GB232763@bhelgaas-glaptop.roam.corp.google.com>
Date: Mon, 29 Jan 2018 20:41:07 +0200
In-Reply-To: <20180129180349.GB232763@bhelgaas-glaptop.roam.corp.google.com>
        (Bjorn Helgaas's message of "Mon, 29 Jan 2018 12:03:49 -0600")
Message-ID: <87wp00qzi4.fsf@kamboji.qca.qualcomm.com> (sfid-20180129_194115_831381_4B979AEC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn Helgaas <helgaas@kernel.org> writes:

> On Thu, Jan 25, 2018 at 12:13:39PM +0100, Tobias Schramm wrote:
>> Signed-off-by: Tobias Schramm <tobleminer@gmail.com>
>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>
> I see Kalle has already applied this, but if it's updated for any reason,
> please add my ack and change the subject to:
>
>   PCI: Add Ubiquiti Networks vendor ID
>
> i.e., match the style of previous changes.

I only applied it to my pending branch which I use for build testing
etc. and I can easily change it, which I now did:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=3c4cdd0851bc114f8b6d9f9db0b0479737bbd2d8

-- 
Kalle Valo
