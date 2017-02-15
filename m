Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:36479 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdBOKjC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 05:39:02 -0500
Received: by mail-ua0-f171.google.com with SMTP id 96so103145616uaq.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 02:39:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <dea21c18-30a4-f236-6f8b-1bf8d4391e0b@broadcom.com>
References: <CANU0Mn00ju_SZ3L+ipdnZ5R-Y1m+T=MhjHmBjMpKN_i8NPWsrg@mail.gmail.com>
 <dea21c18-30a4-f236-6f8b-1bf8d4391e0b@broadcom.com>
From: ravin goyal <ravirocks1021@gmail.com>
Date: Wed, 15 Feb 2017 16:08:41 +0530
Message-ID: <CANU0Mn2Fp=3tYb70qD7J_duA0f1wbRNr_Q3e5iv3pBTHtWM4zg@mail.gmail.com> (sfid-20170215_113937_897774_AB16D6AD)
Subject: Re: wireless driver crashing frequently
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

that is what I have found on my banana pi board running raspbian lite
3.4.112-sun8i.
removing bcmdhd results in removing my wlan0 interface from the
list(iwconfig/ifconfig/ip).

Regards
Ravin
