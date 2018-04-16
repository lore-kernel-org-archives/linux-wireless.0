Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:16982 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752481AbeDPRZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 13:25:00 -0400
Date: Mon, 16 Apr 2018 10:24:52 -0700
From: Jakub Kicinski <kubakici@wp.pl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] mt7601u: run calibration works after finishing
 scanning
Message-ID: <20180416102452.09f0a9bc@cakuba.netronome.com> (sfid-20180416_192503_829874_D1979EEA)
In-Reply-To: <1523879778-6455-2-git-send-email-sgruszka@redhat.com>
References: <1523879778-6455-1-git-send-email-sgruszka@redhat.com>
        <1523879778-6455-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 16 Apr 2018 13:56:18 +0200, Stanislaw Gruszka wrote:
> When finishing scanning we switch to operational channel sill with
> SCANNING flag. This mean that we never perform calibration works after
> scanning. To fix the problem queue calibration works on
> .sw_scan_complete() routine.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>

Thank you!!
