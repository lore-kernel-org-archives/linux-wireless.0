Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36277 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752887AbdBGJ5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 04:57:52 -0500
Subject: Re: [PATCH v4 3/3] mt76: add driver code for MT76x2e
To: Stanislaw Gruszka <sgruszka@redhat.com>
References: <20170202115208.8614-1-nbd@nbd.name>
 <20170202115208.8614-4-nbd@nbd.name> <20170206112508.GA9255@redhat.com>
 <3f9febb5-696e-884b-7c9a-76866f3e55e9@nbd.name>
 <20170206131400.GA2716@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <6c4b1371-096d-d404-ed32-cfd8bce96a63@nbd.name> (sfid-20170207_105757_432151_CF134BB8)
Date: Tue, 7 Feb 2017 10:57:47 +0100
MIME-Version: 1.0
In-Reply-To: <20170206131400.GA2716@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-06 14:14, Stanislaw Gruszka wrote:
> CCK can be used only on 5GHz? OFDM only on 2GHz? I thought any rates can
> be used on both bands. Or maybe this settings is just named wrongly
> i.e. CCK_SIFS mean sifs for 5GHz and OFDM_SIFS - sifs for 2GHz ?
OFDM is used on 2.4 and 5 GHz, CCK only on 2.4 GHz.
According to the datasheet, CCK_SIFS means SIFS after CCK transmission.

- Felix
