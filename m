Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51968 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdF1Sex (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 14:34:53 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "pavani.muthyala" <pavani.muthyala@redpinesignals.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [v2 11/20] rsi: management frame descriptor preparation cleanup
References: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
        <1497624881-2315-12-git-send-email-amit.karwar@redpinesignals.com>
Date: Wed, 28 Jun 2017 21:34:48 +0300
In-Reply-To: <1497624881-2315-12-git-send-email-amit.karwar@redpinesignals.com>
        (Amitkumar Karwar's message of "Fri, 16 Jun 2017 20:24:32 +0530")
Message-ID: <87podo2c6v.fsf@purkki.adurom.net> (sfid-20170628_203509_218709_D7229FBB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: "pavani.muthyala" <pavani.muthyala@redpinesignals.com>
>
> Currently this descriptor is prepared with the help of __le16
> pointer. This patch makes use of a structure to prepare the
> descriptor in a cleaner way.
>
> Signed-off-by: pavani.muthyala <pavani.muthyala@redpinesignals.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Pavani's name is in wrong format both in Format and S-o-b lines. 

-- 
Kalle Valo
