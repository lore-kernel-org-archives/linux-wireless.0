Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.25]:16619 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbeG3L1D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 07:27:03 -0400
Received: from dynamic.fami-braun.de
        by smtp.strato.de (RZmta 43.13 DYNA|AUTH)
        with ESMTPSA id D0777du6U9eb0B9
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <linux-wireless@vger.kernel.org>;
        Mon, 30 Jul 2018 11:40:37 +0200 (CEST)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id 077A215427C
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2018 11:40:37 +0200 (CEST)
Received: from [10.132.65.213] (x2f7f9d5.dyn.telefonica.de [2.247.249.213])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTPSA id A8723158238
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2018 11:40:33 +0200 (CEST)
Date: Mon, 30 Jul 2018 11:40:31 +0200
In-Reply-To: <8ecda6f3-68ab-5752-c8de-4086d21ba309@candelatech.com>
References: <8ecda6f3-68ab-5752-c8de-4086d21ba309@candelatech.com>
MIME-Version: 1.0
Content-Type: multipart/alternative; boundary="----9ZVUQ48V6ZIUF2V3CDI6VCHQ0EJEJ9"
Subject: Re: ath9k and 16 VAP interfaces?
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: michael-dev@fami-braun.de
Message-ID: <EB834EF3-21B2-4E6F-BEA8-1411407310F0@fami-braun.de> (sfid-20180730_115255_346571_75165488)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------9ZVUQ48V6ZIUF2V3CDI6VCHQ0EJEJ9
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Do you mean AP interfaces as required for multiple BSS/SSIDs?

I'm running a patched ath9k to have hostapd run >8 BSS on a single radio=
=2E
It works fine since years=2E

Regards,
M=2E Braun


Am 27=2E Juli 2018 15:35:28 MESZ schrieb Ben Greear <greearb@candelatech=
=2Ecom>:
>Hello,
>
>Has anyone tried making ath9k able to support 16 vAP interfaces on a
>single
>radio?  I seem to recall that there were limitations regarding beacon
>timers and such, and that is why the current limit is 8?
>
>Thanks,
>Ben
>
>--=20
>Ben Greear <greearb@candelatech=2Ecom>
>Candela Technologies Inc  http://www=2Ecandelatech=2Ecom

------9ZVUQ48V6ZIUF2V3CDI6VCHQ0EJEJ9
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body>Do you mean AP interfaces as required for multiple=
 BSS/SSIDs?<br>
<br>
I&#39;m running a patched ath9k to have hostapd run &gt;8 BSS on a single =
radio=2E<br>
It works fine since years=2E<br>
<br>
Regards,<br>
M=2E Braun<br>
<br><br><div class=3D"gmail_quote">Am 27=2E Juli 2018 15:35:28 MESZ schrie=
b Ben Greear &lt;greearb@candelatech=2Ecom&gt;:<blockquote class=3D"gmail_q=
uote" style=3D"margin: 0pt 0pt 0pt 0=2E8ex; border-left: 1px solid rgb(204,=
 204, 204); padding-left: 1ex;">
<pre class=3D"k9mail">Hello,<br><br>Has anyone tried making ath9k able to =
support 16 vAP interfaces on a single<br>radio?  I seem to recall that ther=
e were limitations regarding beacon<br>timers and such, and that is why the=
 current limit is 8?<br><br>Thanks,<br>Ben<br></pre></blockquote></div></bo=
dy></html>
------9ZVUQ48V6ZIUF2V3CDI6VCHQ0EJEJ9--
