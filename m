Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49759 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2DXGpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 02:45:33 -0400
Received: by obbta14 with SMTP id ta14so672034obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 23:45:32 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 23 Apr 2012 23:45:12 -0700
Message-ID: <CAB=NE6USio_AyOL6duU-9ZC7vp0+kSXJ=VKJwHqBH_B_MBDH2Q@mail.gmail.com> (sfid-20120424_084536_345310_D5163C22)
Subject: compat-wireless-2012-04-23 back on track with ckmake
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're back on track with compilation against all supported kernels.

   mcgrof@flash ~/devel/compat-wireless (git::master)$ time ckmake; time ckmake
    Trying kernel                  3.4.0-030400rc4-generic  [OK]
    Trying kernel                     3.3.3-030303-generic  [OK]
    Trying kernel                     3.2.2-030202-generic  [OK]
    Trying kernel                    3.1.10-030110-generic  [OK]
    Trying kernel                    3.0.18-030018-generic  [OK]
    Trying kernel                  2.6.39-02063904-generic  [OK]
    Trying kernel                  2.6.38-02063808-generic  [OK]
    Trying kernel                  2.6.37-02063706-generic  [OK]
    Trying kernel                  2.6.36-02063604-generic  [OK]
    Trying kernel                  2.6.35-02063512-generic  [OK]
    Trying kernel                  2.6.34-02063410-generic  [OK]
    Trying kernel                  2.6.33-02063305-generic  [OK]
    Trying kernel                  2.6.32-02063255-generic  [OK]
    Trying kernel                  2.6.31-02063113-generic  [OK]
    Trying kernel                  2.6.30-02063010-generic  [OK]
    Trying kernel                  2.6.29-02062906-generic  [OK]
    Trying kernel                  2.6.28-02062810-generic  [OK]
    Trying kernel                    2.6.27-020627-generic  [OK]
    Trying kernel                    2.6.26-020626-generic  [OK]
    Trying kernel                    2.6.25-020625-generic  [OK]
    Trying kernel                    2.6.24-020624-generic  [OK]

    real    94m39.991s
    user    287m51.955s
    sys     26m37.828s

    real    18m20.621s
    user    41m8.998s
    sys     8m59.742s

  Luis
