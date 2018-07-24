Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37450 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388640AbeGXVcG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 17:32:06 -0400
Received: by mail-lj1-f195.google.com with SMTP id v9-v6so4718011ljk.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2018 13:23:56 -0700 (PDT)
Date: Tue, 24 Jul 2018 22:23:53 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: bjorn.andersson@linaro.org, david.brown@linaro.org,
        andy.gross@linaro.org, robh@kernel.org, devicetree@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 0/6] *** Add support for wifi QMI client handshakes ***
Message-ID: <20180724202353.GA14174@centauri.lan> (sfid-20180724_222400_527863_B4CFAC3D)
References: <20180723123428.12993-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180723123428.12993-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 23, 2018 at 06:04:22PM +0530, Govind Singh wrote:
> Add QMI client handshakes for Q6 integrated WLAN connectivity subsystem.
> This module is responsible for communicating WLAN control messages to FW
> over QMI interface. This patch series enables the qmi handshakes required for
> WCN3990 chipset.
> 
> QUALCOMM MSM Interface(QMI) provides the control interface between
> components running b/w remote processors with underlying transport layer
> based on integrated chipset(shared memory) or discrete chipset(PCI/USB/SDIO/UART).
> 
> QMI client driver implementation is based on qmi framework https://lwn.net/Articles/729924/.

For whole series:

Acked-by: Niklas Cassel <niklas.cassel@linaro.org>
