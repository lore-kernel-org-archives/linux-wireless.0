Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35684 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947917AbdDZEyY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 00:54:24 -0400
Received: by mail-pf0-f194.google.com with SMTP id a188so13975684pfa.2
        for <linux-wireless@vger.kernel.org>; Tue, 25 Apr 2017 21:54:23 -0700 (PDT)
Date: Tue, 25 Apr 2017 22:54:16 -0600
From: Jason Litzinger <jlitzingerdev@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH RFC] staging: wilc1000: Refactor handling of HT caps
 fields
Message-ID: <20170426045416.GA20613@arch-tinker.localdomain> (sfid-20170426_065428_611733_499C2961)
References: <20170426044625.20529-1-jlitzingerdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170426044625.20529-1-jlitzingerdev@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +			strStaParams.ht_capa = *params->ht_capa;
Doh, that's completely wrong.  I had a few iterations of this and sent
the wrong version.  There's an embedded array in that struct (not an
embedded struct as I though during one read through).

Will fix and re-send, sorry for the spam.

-Jason
