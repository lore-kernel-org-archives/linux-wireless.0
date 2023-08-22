Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11748EE49A3
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Aug 2023 01:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjHWBnL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Aug 2023 21:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjHWBnJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2023 21:43:09 -0400
X-Greylist: delayed 903 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Aug 2023 18:43:07 PDT
Received: from symantec4.comsats.net.pk (symantec4.comsats.net.pk [203.124.41.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA4310D
        for <linux-wireless@vger.kernel.org>; Tue, 22 Aug 2023 18:43:07 -0700 (PDT)
X-AuditID: cb7c291e-055ff70000002aeb-4a-64e54bbc1487
Received: from iesco.comsatshosting.com (iesco.comsatshosting.com [210.56.28.11])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by symantec4.comsats.net.pk (Symantec Messaging Gateway) with SMTP id 8A.FB.10987.CBB45E46; Wed, 23 Aug 2023 04:58:52 +0500 (PKT)
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns;
        d=iesco.com.pk; s=default;
        h=received:content-type:mime-version:content-transfer-encoding
          :content-description:subject:to:from:date:reply-to;
        b=Iv3XUMQX6Ac0PK7RZ0i8XFxafWwbcxYEr30FPsAO80kZzTA76gZ6JoiWmAygJKgUk
          Nl866WloF7VaFtwKLJyl9Kq3MiWPnqc9IDYbB09tz4hUY6AaWtm0H9ygR6HsvoBtS
          11lQUPZqJYCLkiMTSPUpfWZhh/7iuSN/0rx2v5xJk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iesco.com.pk; s=default;
        h=reply-to:date:from:to:subject:content-description
          :content-transfer-encoding:mime-version:content-type;
        bh=GMzYzcyTxDsE6wX/XHG6MHqAdAiHrhqbmmLQ/TZ1QnQ=;
        b=iLwG9Ifq1ssJ9R0jWdo7ZGR6y/5vEY6w4bVSObakxw1SokyAsT83JlVT1mS2yFwRG
          SPlpv71Y8x1i5BC1WLrBZfmZpEqo1DsgLjdjnsMee32yQJ6AS33u4GRle+1lQIO4e
          Y53/aCrpFLeU1MpxAMSjiJsJkwodL7PgUFncFqLCY=
Received: from [94.156.6.90] (UnknownHost [94.156.6.90]) by iesco.comsatshosting.com with SMTP;
   Wed, 23 Aug 2023 04:31:09 +0500
Message-ID: <8A.FB.10987.CBB45E46@symantec4.comsats.net.pk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re; Interest,
To:     linux-wireless@vger.kernel.org
From:   "Chen Yun" <pso.chairmanbod@iesco.com.pk>
Date:   Tue, 22 Aug 2023 16:31:23 -0700
Reply-To: chnyne@gmail.com
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVyyUKGW3eP99MUg+PvxC3erLjD7sDo8XmT
        XABjFJdNSmpOZllqkb5dAlfGknUXWAp2M1e09S9iaWB8zNTFyMEhIWAisXhhUhcjF4eQwB4m
        iRsfJ7GAOCwCq5kllrTtYoVwHjJLTLn7AaiDE6ismVHi/FEzEJtXwFri0pJTrCA2s4CexI2p
        U9gg4oISJ2c+YYGIa0ssW/iaGWQbs4CaxNeuEpCwsICYxKdpy9hBbBEBJYneC6uYQWw2AX2J
        FV+bGUFsFgFViccHd7NArJWS2HhlPdsERv5ZSLbNQrJtFpJtsxC2LWBkWcUoUVyZmwgMtGQT
        veT83OLEkmK9vNQSvYLsTYzAIDxdoym3g3HppcRDjAIcjEo8vD/XPUkRYk0sA+o6xCjBwawk
        wiv9/WGKEG9KYmVValF+fFFpTmrxIUZpDhYlcV5boWfJQgLpiSWp2ampBalFMFkmDk6pBsZA
        6R6dx3Eb1831OCD8uMJS/J9K6hTp2GksVl0b3TvOX5cPYnwu9eb3o/amA4LH7NQMXjWlCaiv
        e35LluGIDdOVHWl33y3epNirocf+NNzMytBjs7dd9eNMg/QXfq+cngSVBGpqFf7pc7XnYleJ
        jn6bMC05/eR5decX4Us/HLh2L2TW7fuiIUosxRmJhlrMRcWJAMCYjZg+AgAA
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Re; Interest,

I am interested in discussing the Investment proposal as I explained
in my previous mail. May you let me know your interest and the
possibility of a cooperation aimed for mutual interest.

Looking forward to your mail for further discussion.

Regards

------
Chen Yun - Chairman of CREC
China Railway Engineering Corporation - CRECG
China Railway Plaza, No.69 Fuxing Road, Haidian District, Beijing, P.R.
China

