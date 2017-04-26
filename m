Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35125 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1949172AbdDZFYW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 01:24:22 -0400
Received: by mail-pg0-f67.google.com with SMTP id 68so1071727pgj.2
        for <linux-wireless@vger.kernel.org>; Tue, 25 Apr 2017 22:24:22 -0700 (PDT)
Date: Tue, 25 Apr 2017 23:24:14 -0600
From: Jason Litzinger <jlitzingerdev@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH RFC] staging: wilc1000: Refactor handling of HT caps
 fields
Message-ID: <20170426052351.GA7735@arch-tinker.localdomain> (sfid-20170426_072426_718252_C83E3A26)
References: <20170426044625.20529-1-jlitzingerdev@gmail.com>
 <20170426045416.GA20613@arch-tinker.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170426045416.GA20613@arch-tinker.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 25, 2017 at 10:54:16PM -0600, Jason Litzinger wrote:
> > +			strStaParams.ht_capa = *params->ht_capa;
> Doh, that's completely wrong.  I had a few iterations of this and sent
No, it wasn't.  The PATCH RFC I sent initally is correct.  Apologies, had a
C brain gap and worried about deep copying that array embedded in the
struct.

-Jason
