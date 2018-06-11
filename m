Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:7133 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751148AbeFKWGM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 18:06:12 -0400
Date: Mon, 11 Jun 2018 14:59:25 -0700
From: Jakub Kicinski <kubakici@wp.pl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>
Subject: Re: [PATCH] mt7601u: remove warning when avg_rssi is zero
Message-ID: <20180611145925.02766c3f@cakuba.netronome.com> (sfid-20180612_000616_067864_387F7212)
In-Reply-To: <20180609101043.GA28502@redhat.com>
References: <20180609101043.GA28502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 9 Jun 2018 12:10:44 +0200, Stanislaw Gruszka wrote:
> It turned out that we can run calibration without already received
> frames with RSSI data. In such case just don't update AGC register
> and don't print the warning.
> 
> Fixes: b305a6ab0247 ("mt7601u: use EWMA to calculate avg_rssi")
> Reported-by: Adam Borowski <kilobyte@angband.pl>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
